part of 'category_recipe_bloc.dart';

@immutable
class CategoryRecipeState extends Equatable {
  final CategoryStatus status;
  CategoryRecipeResponse? categoryResponse;
  RecipeCategoryModel? data;
  ServerError? error;
  CategoryRecipeState({
    required this.status,
    this.data,
  });

  @override
  List<Object> get props => [status];
  CategoryRecipeState copyWith(
    CategoryStatus? status,
    CategoryRecipeResponse? response,
    RecipeCategoryModel? dataResponse,
    ServerError? error,
  ) {
    var newState = CategoryRecipeState(status: status ?? this.status);
    if (response != null) {
      newState.categoryResponse = response;
    }
    if (dataResponse != null) {
      newState.data = dataResponse;
    }

    if (error != null) {
      newState.error = error;
    }

    return newState;
  }
}

enum CategoryStatus {
  Initial,
  Processing,
  Success,
  Failed,
}
