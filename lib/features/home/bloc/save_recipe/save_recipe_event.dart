part of 'save_recipe_bloc.dart';

@immutable
class SaveRecipeEvent extends Equatable {
  const SaveRecipeEvent();

  @override
  List<Object> get props => [];
}

class SaveRecipe extends SaveRecipeEvent {
  String id;
  SaveRecipe(this.id);
}

class SaveRecipeSuccess extends SaveRecipeEvent {
  const SaveRecipeSuccess();
}

class SaveRecipeFailed extends SaveRecipeEvent {
  final ServerError error;
  const SaveRecipeFailed(this.error);
}
