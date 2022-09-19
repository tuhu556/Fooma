part of 'saved_recipe_bloc.dart';

@immutable
class SavedRecipeEvent extends Equatable {
  const SavedRecipeEvent();

  @override
  List<Object> get props => [];
}

class GetSavedRecipe extends SavedRecipeEvent {
  final int page;
  final int size;

  final String sortOption;
  final int role;

  const GetSavedRecipe(
    this.page,
    this.size,
    this.sortOption,
    this.role,
  );
}

class GetSavedRecipeSuccess extends SavedRecipeEvent {
  final RecipeAppResponse data;
  const GetSavedRecipeSuccess(this.data);
}

class GetSavedRecipeFailed extends SavedRecipeEvent {
  final ServerError error;
  const GetSavedRecipeFailed(this.error);
}
