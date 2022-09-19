part of 'upload_recipe_bloc.dart';

@immutable
class UploadRecipeEvent extends Equatable {
  const UploadRecipeEvent();

  @override
  List<Object> get props => [];
}

class UploadRecipe extends UploadRecipeEvent {
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

  UploadRecipe({
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

class UploadRecipeSuccess extends UploadRecipeEvent {
  const UploadRecipeSuccess();
}

class UploadRecipeFailed extends UploadRecipeEvent {
  final ServerError error;
  const UploadRecipeFailed(this.error);
}
