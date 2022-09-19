part of 'edit_recipe_bloc.dart';

@immutable
class EditMyRecipeEvent extends Equatable {
  const EditMyRecipeEvent();

  @override
  List<Object> get props => [];
}

class EditMyRecipe extends EditMyRecipeEvent {
  final String recipeId;
  String? originId;
  String? cookingMethodId;
  String? recipeName;
  String? description;
  int? preparationTime;
  int? cookingTime;
  int? serves;
  double? calories;
  String? hashtag;
  List<RecipeCategoriesAdd>? manyToManyRecipeCategories;
  List<ManyToManyRecipeNutritions>? manyToManyRecipeNutritions;
  List<RecipeImages>? recipeImages;
  List<RecipeIngredients>? recipeIngredients;
  List<RecipeMethods>? recipeMethods;

  EditMyRecipe({
    required this.recipeId,
    this.originId,
    this.cookingMethodId,
    this.recipeName,
    this.description,
    this.preparationTime,
    this.cookingTime,
    this.serves,
    this.calories,
    this.hashtag,
    this.manyToManyRecipeCategories,
    this.manyToManyRecipeNutritions,
    this.recipeImages,
    this.recipeIngredients,
    this.recipeMethods,
  });
}

class EditMyRecipeSuccess extends EditMyRecipeEvent {
  const EditMyRecipeSuccess();
}

class EditMyRecipeFailed extends EditMyRecipeEvent {
  final ServerError error;
  const EditMyRecipeFailed(this.error);
}
