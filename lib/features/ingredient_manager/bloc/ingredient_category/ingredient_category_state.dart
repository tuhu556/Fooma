part of 'ingredient_category_bloc.dart';

@immutable
class IngredientCategoryState extends Equatable {
  final IngredientCategoryStatus status;
  IngredientCategoryResponse? ingredientCategoryResponse;
  IngredientCategoryModel? ingredientCategoryModel;
  ServerError? error;
  IngredientCategoryState({
    required this.status,
    this.ingredientCategoryModel,
  });

  @override
  List<Object> get props => [status];
  IngredientCategoryState copyWith(
    IngredientCategoryStatus? status,
    IngredientCategoryResponse? response,
    IngredientCategoryModel? dataResponse,
    ServerError? error,
  ) {
    var newState = IngredientCategoryState(status: status ?? this.status);
    if (response != null) {
      newState.ingredientCategoryResponse = response;
    }
    if (dataResponse != null) {
      newState.ingredientCategoryModel = dataResponse;
    }

    if (error != null) {
      newState.error = error;
    }

    return newState;
  }
}

enum IngredientCategoryStatus {
  Initial,
  Processing,
  Success,
  Failed,
}
