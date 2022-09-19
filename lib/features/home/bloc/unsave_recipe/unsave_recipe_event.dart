part of 'unsave_recipe_bloc.dart';

@immutable
class UnsaveRecipeEvent extends Equatable {
  const UnsaveRecipeEvent();

  @override
  List<Object> get props => [];
}

class UnSaveRecipe extends UnsaveRecipeEvent {
  String id;
  UnSaveRecipe(this.id);
}

class UnSaveRecipeSuccess extends UnsaveRecipeEvent {
  const UnSaveRecipeSuccess();
}

class UnSaveRecipeFailed extends UnsaveRecipeEvent {
  final ServerError error;
  const UnSaveRecipeFailed(this.error);
}
