import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/category.dart';
import '../../repositories/category_repository.dart';
import '../../services/data_sync_service.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository categoryRepository;
  final DataSyncService _dataSyncService = DataSyncService();

  CategoryBloc({required this.categoryRepository}) : super(CategoryInitial()) {
    on<LoadCategories>(_onLoadCategories);
    on<AddCategory>(_onAddCategory);
    on<UpdateCategory>(_onUpdateCategory);
    on<DeleteCategory>(_onDeleteCategory);
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
      final List<Category> updatedCategories = List.from((state as CategoryLoaded).categories)..add(event.category);
      emit(CategoryLoaded(updatedCategories));
      await categoryRepository.addCategory(event.category);

      // Sync to Firestore if user is signed in
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          await _dataSyncService.syncToFirestore(user.uid);
        } catch (e) {
          log('Failed to sync category addition to Firestore: $e');
        }
      }
    }
  }

  Future<void> _onUpdateCategory(UpdateCategory event, Emitter<CategoryState> emit) async {
    if (state is CategoryLoaded) {
      final List<Category> updatedCategories = (state as CategoryLoaded).categories.map((category) {
        return category.id == event.category.id ? event.category : category;
      }).toList();
      emit(CategoryLoaded(updatedCategories));
      await categoryRepository.updateCategory(event.category);

      // Sync to Firestore if user is signed in
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          await _dataSyncService.syncToFirestore(user.uid);
        } catch (e) {
          log('Failed to sync category update to Firestore: $e');
        }
      }
    }
  }

  Future<void> _onDeleteCategory(DeleteCategory event, Emitter<CategoryState> emit) async {
    if (state is CategoryLoaded) {
      final List<Category> updatedCategories = (state as CategoryLoaded).categories.where((category) => category.id != event.categoryId).toList();
      emit(CategoryLoaded(updatedCategories));
      await categoryRepository.deleteCategory(event.categoryId);

      // Sync to Firestore if user is signed in
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          await _dataSyncService.syncToFirestore(user.uid);
        } catch (e) {
          log('Failed to sync category deletion to Firestore: $e');
        }
      }
    }
  }
}
