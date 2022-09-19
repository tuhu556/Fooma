part of 'saved_recipe_bloc.dart';

@immutable
class SavedRecipeState extends Equatable {
  final SavedRecipeStatus status;
  RecipeAppResponse? recipeResponse;
  RecipeAppModel? recipeAppModel;
  ServerError? error;
  SavedRecipeState({
    required this.status,
    this.recipeAppModel,
  });
  @override
  List<Object> get props => [status];
  SavedRecipeState copyWith(
    SavedRecipeStatus? status,
    RecipeAppResponse? recipeResponse,
    RecipeAppModel? recipeAppModel,
    ServerError? error,
  ) {
    var newState = SavedRecipeState(status: status ?? this.status);

    if (recipeResponse != null) {
      newState.recipeResponse = recipeResponse;
    }
    if (recipeAppModel != null) {
      newState.recipeAppModel = recipeAppModel;
    }
    if (error != null) {
      newState.error = error;
    }

    return newState;
  }
}

enum SavedRecipeStatus {
  Initial,
  Processing,
  Success,
  Failed,
}
