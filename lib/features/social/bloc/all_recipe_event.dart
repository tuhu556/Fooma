part of 'all_recipe_bloc.dart';

@immutable
class AllRecipeEvent extends Equatable {
  const AllRecipeEvent();

  @override
  List<Object> get props => [];
}

class AllRecipe extends AllRecipeEvent {
  final int page;
  const AllRecipe(this.page);
}

class GetAllRecipeSuccess extends AllRecipeEvent {
  final RecipeResponse listRecipe;
  const GetAllRecipeSuccess(this.listRecipe);
}

class GetAllRecipeFailed extends AllRecipeEvent {
  final ServerError error;
  const GetAllRecipeFailed(this.error);
}
