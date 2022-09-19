part of 'option_recipe_bloc.dart';

@immutable
class OptionRecipeState extends Equatable {
  final OptionRecipeStatus status;
  RecipeOriginResponse? recipeOrigin;
  RecipeMealResponse? recipeMeal;
  RecipeProcessResponse? recipeProcess;
  IngredientResponse? ingredient;
  ServerError? error;

  OptionRecipeState({required this.status});

  List<Object> get props => [status];

  OptionRecipeState copyWith(
      OptionRecipeStatus? status,
      RecipeOriginResponse? recipeOrigin,
      RecipeMealResponse? recipeMeal,
      RecipeProcessResponse? recipeProcess,
      IngredientResponse? ingredient,
      ServerError? error) {
    var newState = OptionRecipeState(status: status ?? this.status);
    if (recipeOrigin != null) {
      newState.recipeOrigin = recipeOrigin;
    }
    if (recipeMeal != null) {
      newState.recipeMeal = recipeMeal;
    }

    if (recipeProcess != null) {
      newState.recipeProcess = recipeProcess;
    }
    if (ingredient != null) {
      newState.ingredient = ingredient;
    }
    if (error != null) {
      newState.error = error;
    }

    return newState;
  }
}

enum OptionRecipeStatus {
  Initial,
  Processing,
  Success,
  Failed,
  MealInitial,
  MealProcessing,
  MealSuccess,
  MealFailed,
  ProcessInitial,
  ProcessProcessing,
  ProcessSuccess,
  ProcessFailed,
  IngredientInitial,
  IngredientProcessing,
  IngredientSuccess,
  IngredientFailed,
}
