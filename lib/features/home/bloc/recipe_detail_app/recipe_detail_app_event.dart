part of 'recipe_detail_app_bloc.dart';

@immutable
class RecipeDetailAppEvent extends Equatable {
  const RecipeDetailAppEvent();

  @override
  List<Object> get props => [];
}

class RecipeDetail extends RecipeDetailAppEvent {
  final String recipeId;
  const RecipeDetail(this.recipeId);
}

class GetRecipeDetailSuccess extends RecipeDetailAppEvent {
  final RecipeDetailAppModel data;
  const GetRecipeDetailSuccess(this.data);
}

class GetRecipeDetailFailed extends RecipeDetailAppEvent {
  final ServerError error;
  const GetRecipeDetailFailed(this.error);
}
