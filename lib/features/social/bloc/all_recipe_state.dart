part of 'all_recipe_bloc.dart';

@immutable
class AllRecipeState extends Equatable {
  final AllRecipeStatus status;

  RecipeResponse? allRecipe;

  ServerError? error;

  AllRecipeState({required this.status});

  List<Object> get props => [status];

  AllRecipeState copyWith(
      AllRecipeStatus? status, RecipeResponse? allRecipe, ServerError? error) {
    var newState = AllRecipeState(status: status ?? this.status);

    if (allRecipe != null) {
      newState.allRecipe = allRecipe;
    }

    if (error != null) {
      newState.error = error;
    }

    return newState;
  }
}

enum AllRecipeStatus {
  Initial,
  Processing,
  Success,
  Failed,
}
