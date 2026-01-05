
import 'package:bloc/bloc.dart';
import '../../models/category.dart';
import '../../repositories/category_repository.dart';
import '../../repositories/task_repository.dart';
import '../../services/sync_queue.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository categoryRepository;
  final TaskRepository taskRepository;

  CategoryBloc({required this.categoryRepository, required this.taskRepository}) : super(CategoryInitial()) {
    on<LoadCategories>(_onLoadCategories);
    on<AddCategory>(_onAddCategory);
    on<UpdateCategory>(_onUpdateCategory);
    on<DeleteCategory>(_onDeleteCategory);
    on<CheckCategoryDeletion>(_onCheckCategoryDeletion);
  }

  Future<void> _onLoadCategories(LoadCategories event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    try {
      final categories = await categoryRepository.getAllCategories();
      emit(CategoryLoaded(categories));
    } catch (e) {
      emit(CategoryError('Failed to load categories'));
    }
  }

  Future<void> _onAddCategory(AddCategory event, Emitter<CategoryState> emit) async {
    if (state is CategoryLoaded) {
      // Persist FIRST to prevent data loss on crash
      await categoryRepository.addCategory(event.category);

      final List<Category> updatedCategories = List.from((state as CategoryLoaded).categories)..add(event.category);
      emit(CategoryLoaded(updatedCategories));

      // Queue for sync instead of immediate sync
      syncQueue.enqueueCategoryCreate(event.category);
    }
  }

  Future<void> _onUpdateCategory(UpdateCategory event, Emitter<CategoryState> emit) async {
    if (state is CategoryLoaded) {
      // Persist FIRST to prevent data loss on crash
      await categoryRepository.updateCategory(event.category);

      final List<Category> updatedCategories = (state as CategoryLoaded).categories.map((category) {
        return category.id == event.category.id ? event.category : category;
      }).toList();
      emit(CategoryLoaded(updatedCategories));

      // Queue for sync instead of immediate sync
      syncQueue.enqueueCategoryUpdate(event.category);
    }
  }

  Future<void> _onDeleteCategory(DeleteCategory event, Emitter<CategoryState> emit) async {
    if (state is CategoryLoaded) {
      // Persist FIRST to prevent data loss on crash
      await categoryRepository.deleteCategory(event.categoryId);

      final List<Category> updatedCategories = (state as CategoryLoaded).categories.where((category) => category.id != event.categoryId).toList();
      emit(CategoryLoaded(updatedCategories));

      // Queue for sync instead of immediate sync
      syncQueue.enqueueCategoryDelete(event.categoryId);
    }
  }

  Future<void> _onCheckCategoryDeletion(CheckCategoryDeletion event, Emitter<CategoryState> emit) async {
    if (state is CategoryLoaded) {
      try {
        // Find the category
        final category = (state as CategoryLoaded).categories.firstWhere((cat) => cat.id == event.categoryId);

        // Count tasks in this category
        final allTasks = await taskRepository.getAllTasks();
        final tasksInCategory = allTasks.where((task) => task.categoryId == event.categoryId).length;

        // Emit warning state with task count
        emit(CategoryDeletionWarning(event.categoryId, category.name, tasksInCategory));
      } catch (e) {
        emit(CategoryError('Failed to check category deletion: $e'));
      }
    }
  }
}
