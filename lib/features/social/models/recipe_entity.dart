class RecipeResponse {
  List<Recipe> recipe;
  int totalPage;
  RecipeResponse(this.recipe, this.totalPage);

  factory RecipeResponse.fromJson(Map<String, dynamic> json) {
    final listRecipe =
        (json["items"] as List).map((e) => Recipe.fromJson(e)).toList();
    final totalPage = json["totalPage"];
    return RecipeResponse(listRecipe, totalPage);
  }
}

class Recipe {
  final String id;
  final String userID;
  final String name;
  final String userImageUrl;
  final String originId;
  final String originName;
  final String cookingMethodId;
  final String cookingMethodName;
  final String recipeName;
  final String createDate;
  final String publishedDate;
  final String description;
  final String thumbnail;
  final int preparationTime;
  final int cookingTime;
  final int serves;
  final double calories;
  final String hashtag;
  final String role;
  final String reason;
  int totalComment;
  int totalReact;
  bool isReacted;
  bool isSaved;
  final int status;
  final List<RecipeCategories> manyToManyRecipeCategories;
  final List<Ingredient> ingredient;

  Recipe(
    this.id,
    this.userID,
    this.name,
    this.userImageUrl,
    this.originId,
    this.originName,
    this.cookingMethodId,
    this.cookingMethodName,
    this.recipeName,
    this.createDate,
    this.publishedDate,
    this.description,
    this.thumbnail,
    this.preparationTime,
    this.cookingTime,
    this.serves,
    this.calories,
    this.hashtag,
    this.role,
    this.reason,
    this.totalComment,
    this.totalReact,
    this.isReacted,
    this.isSaved,
    this.status,
    this.manyToManyRecipeCategories,
    this.ingredient,
  );
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      json["id"] ?? "",
      json["userId"] ?? "",
      json["name"] ?? "",
      json['userImageUrl'] ?? "",
      json["originId"] ?? "",
      json["originName"] ?? "",
      json["cookingMethodId"] ?? "",
      json["cookingMethodName"] ?? "",
      json["recipeName"] ?? "",
      json['createDate'] ?? "",
      json['publishedDate'] ?? "",
      json["description"] ?? "",
      json["thumbnail"] ?? "",
      json["preparationTime"] ?? "",
      json["cookingTime"] ?? "",
      json["serves"] ?? "",
      json['calories'] ?? "",
      json["hashtag"] ?? "",
      json["role"] ?? "",
      json["reason"] ?? "Không có",
      json["totalComment"] ?? "",
      json["totalReact"] ?? "",
      json["isReacted"] ?? "",
      json["isSaved"] ?? "",
      json["status"] ?? "",
      (List<dynamic>.from(json["manyToManyRecipeCategories"]))
          .map((e) => RecipeCategories.fromJson(e))
          .toList(),
      (List<dynamic>.from(json["recipeIngredients"]))
          .map((e) => Ingredient.fromJson(e))
          .toList(),
    );
  }
}

class RecipeCategories {
  final String recipeCategoryId;
  final String recipeCategoryName;
  RecipeCategories(this.recipeCategoryId, this.recipeCategoryName);
  factory RecipeCategories.fromJson(Map<String, dynamic> json) {
    return RecipeCategories(
      json["recipeCategoryId"] ?? "",
      json["recipeCategoryName"] ?? "",
    );
  }
}

class Ingredient {
  final String ingredientDbid;
  final String ingredientName;
  final double quantity;
  final String unit;
  final bool isMain;
  final int status;

  Ingredient(this.ingredientDbid, this.ingredientName, this.quantity, this.unit,
      this.isMain, this.status);
  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      json["ingredientDbid"] ?? '',
      json["ingredientName"] ?? '',
      json["quantity"] ?? '',
      json["unit"] ?? "",
      json["isMain"] ?? '',
      json["status"] ?? '',
    );
  }
}
