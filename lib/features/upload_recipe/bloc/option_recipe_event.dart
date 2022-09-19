part of 'option_recipe_bloc.dart';

@immutable
class OptionRecipeEvent extends Equatable {
  const OptionRecipeEvent();

  @override
  List<Object> get props => [];
}

class RecipeOrigins extends OptionRecipeEvent {
  const RecipeOrigins();
}

class GetRecipeOriginSuccess extends OptionRecipeEvent {
  final RecipeOriginResponse recipeOrigin;
  const GetRecipeOriginSuccess(this.recipeOrigin);
}

class GetRecipeOriginFailed extends OptionRecipeEvent {
  final ServerError error;
  const GetRecipeOriginFailed(this.error);
}

class RecipeMeals extends OptionRecipeEvent {
  const RecipeMeals();
}

class GetRecipeMealSuccess extends OptionRecipeEvent {
  final RecipeMealResponse recipeMeal;
  const GetRecipeMealSuccess(this.recipeMeal);
}

class GetRecipeMealFailed extends OptionRecipeEvent {
  final ServerError error;
  const GetRecipeMealFailed(this.error);
}

class RecipeProcesss extends OptionRecipeEvent {
  const RecipeProcesss();
}

class GetRecipeProcessSuccess extends OptionRecipeEvent {
  final RecipeProcessResponse recipeProcess;
  const GetRecipeProcessSuccess(this.recipeProcess);
}

class GetRecipeProcessFailed extends OptionRecipeEvent {
  final ServerError error;
  const GetRecipeProcessFailed(this.error);
}

class IngredientDB extends OptionRecipeEvent {
  const IngredientDB();
}

class GetIngredientDBSuccess extends OptionRecipeEvent {
  final IngredientResponse ingredientResponse;
  const GetIngredientDBSuccess(this.ingredientResponse);
}

class GetIngredientDBFailed extends OptionRecipeEvent {
  final ServerError error;
  const GetIngredientDBFailed(this.error);
}
