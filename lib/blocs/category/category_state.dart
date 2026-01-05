import 'package:equatable/equatable.dart';
import '../../models/category.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<Category> categories;

  const CategoryLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class CategoryError extends CategoryState {
  final String message;

  const CategoryError(this.message);

  @override
  List<Object?> get props => [message];
}

class CategoryDeletionWarning extends CategoryState {
  final String categoryId;
  final String categoryName;
  final int taskCount;

  const CategoryDeletionWarning(this.categoryId, this.categoryName, this.taskCount);

  @override
  List<Object?> get props => [categoryId, categoryName, taskCount];
}
