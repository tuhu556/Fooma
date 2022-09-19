part of 'favorite_recipe_bloc.dart';

@immutable
class MyFavoriteRecipeState extends Equatable {
  final MyFavoriteRecipeStatus status;
  MyFavoriteRecipeResponse? myFavoriteRecipe;
  Recipe? recipeDetail;
  ServerError? error;

  MyFavoriteRecipeState({required this.status, this.recipeDetail});

  List<Object> get props => [status];

  MyFavoriteRecipeState copyWith(
      MyFavoriteRecipeStatus? status,
      MyFavoriteRecipeResponse? myFavoriteRecipe,
      Recipe? recipeDetail,
      ServerError? error) {
    var newState = MyFavoriteRecipeState(status: status ?? this.status);

    if (myFavoriteRecipe != null) {
      newState.myFavoriteRecipe = myFavoriteRecipe;
    }
    if (recipeDetail != null) {
      newState.recipeDetail = recipeDetail;
    }

    if (error != null) {
      newState.error = error;
    }

    return newState;
  }
}

enum MyFavoriteRecipeStatus {
  SaveInitial,
  SaveProcessing,
  SaveSuccess,
  SaveFailed,
  UnSaveInitial,
  UnSaveProcessing,
  UnSaveSuccess,
  UnSaveFailed,
  Initial,
  Processing,
  Success,
  Failed,
  RecipeDetailInitial,
  RecipeDetailProcessing,
  RecipeDetailSuccess,
  RecipeDetailFailed,
}
