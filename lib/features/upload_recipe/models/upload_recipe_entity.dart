class RecipeCategoriesAdd {
  final String recipeCategoryId;

  RecipeCategoriesAdd(
    this.recipeCategoryId,
  );
  factory RecipeCategoriesAdd.fromJson(Map<String, dynamic> json) {
    return RecipeCategoriesAdd(
      json["recipeCategoryId"] ?? "",
    );
  }
}

class ManyToManyRecipeNutritions {
  final String recipeNutritionId;

  ManyToManyRecipeNutritions(
    this.recipeNutritionId,
  );
  factory ManyToManyRecipeNutritions.fromJson(Map<String, dynamic> json) {
    return ManyToManyRecipeNutritions(
      json["recipeNutritionId"] ?? "",
    );
  }
}

class RecipeImages {
  final int orderNumber;
  final String imageUrl;
  final bool isThumbnail;

  RecipeImages(
    this.orderNumber,
    this.imageUrl,
    this.isThumbnail,
  );
  factory RecipeImages.fromJson(Map<String, dynamic> json) {
    return RecipeImages(
      json["orderNumber"],
      json["imageUrl"],
      json["isThumbnail"],
    );
  }
}

class RecipeIngredients {
  final String ingredientDbid;
  final String ingredientName;
  final String unit;
  final double quantity;
  final bool isMain;

  RecipeIngredients(
    this.ingredientDbid,
    this.ingredientName,
    this.unit,
    this.quantity,
    this.isMain,
  );
  factory RecipeIngredients.fromJson(Map<String, dynamic> json) {
    return RecipeIngredients(
      json["ingredientDbid"],
      json["ingredientName"],
      json["unit"],
      json["quantity"],
      json["isMain"],
    );
  }
}

class RecipeMethods {
  final int step;
  final String content;
  final List<RecipeMethodImages> recipeMethodImages;

  RecipeMethods(
    this.step,
    this.content,
    this.recipeMethodImages,
  );
  factory RecipeMethods.fromJson(Map<String, dynamic> json) {
    return RecipeMethods(
      json["step"],
      json["content"],
      json["recipeMethodImages"],
    );
  }
}

class RecipeMethodImages {
  final int orderNumber;
  final String imageUrl;

  RecipeMethodImages(
    this.orderNumber,
    this.imageUrl,
  );
  factory RecipeMethodImages.fromJson(Map<String, dynamic> json) {
    return RecipeMethodImages(
      json["orderNumber"],
      json["imageUrl"],
    );
  }
}
