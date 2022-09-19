part of 'favorite_recipe_bloc.dart';

@immutable
class MyFavoriteRecipeEvent extends Equatable {
  const MyFavoriteRecipeEvent();

  @override
  List<Object> get props => [];
}

class MyFavoriteRecipe extends MyFavoriteRecipeEvent {
  const MyFavoriteRecipe();
}

class GetMyFavoriteRecipeDetailSuccess extends MyFavoriteRecipeEvent {
  final MyFavoriteRecipeResponse data;
  const GetMyFavoriteRecipeDetailSuccess(this.data);
}

class GetMyFavoriteRecipeDetailFailed extends MyFavoriteRecipeEvent {
  final ServerError error;
  const GetMyFavoriteRecipeDetailFailed(this.error);
}

class SaveRecipe extends MyFavoriteRecipeEvent {
  String recipeId;
  SaveRecipe(this.recipeId);
}

class SaveRecipeSuccess extends MyFavoriteRecipeEvent {
  const SaveRecipeSuccess();
}

class SaveRecipeFailed extends MyFavoriteRecipeEvent {
  final ServerError error;
  const SaveRecipeFailed(this.error);
}

class UnSaveRecipe extends MyFavoriteRecipeEvent {
  String recipeId;
  UnSaveRecipe(this.recipeId);
}

class UnSaveRecipeSuccess extends MyFavoriteRecipeEvent {
  const UnSaveRecipeSuccess();
}

class UnSaveRecipeFailed extends MyFavoriteRecipeEvent {
  final ServerError error;
  const UnSaveRecipeFailed(this.error);
}

class GetRecipeDetail extends MyFavoriteRecipeEvent {
  final String recipeId;
  const GetRecipeDetail(this.recipeId);
}

class GetRecipeDetailSuccess extends MyFavoriteRecipeEvent {
  final Recipe data;
  const GetRecipeDetailSuccess(this.data);
}

class GetRecipeDetailFailed extends MyFavoriteRecipeEvent {
  final ServerError error;
  const GetRecipeDetailFailed(this.error);
}
