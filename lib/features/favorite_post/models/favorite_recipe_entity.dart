class MyFavoriteRecipeResponse {
  List<Recipe> favoriteRecipe;
  int totalItem;
  MyFavoriteRecipeResponse(this.favoriteRecipe, this.totalItem);

  factory MyFavoriteRecipeResponse.fromJson(Map<String, dynamic> json) {
    final listFavoriteRecipe =
        (json["items"] as List).map((e) => Recipe.fromJson(e)).toList();
    final totalItem = json["totalItem"];
    return MyFavoriteRecipeResponse(listFavoriteRecipe, totalItem);
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
  final String description;
  final String thumbnail;
  final int preparationTime;
  final int cookingTime;
  final int serves;
  final double calories;
  final String hashtag;
  final String role;
  int totalComment;
  int totalReact;
  bool isReacted;
  bool isSaved;
  final int status;
  final List<RecipeCategories> manyToManyRecipeCategories;
  final List<Ingredient> recipeIngredients;
  // final List<RecipeImages> recipeImages;
  // final List<Method> recipeMethods;
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
    this.description,
    this.thumbnail,
    this.preparationTime,
    this.cookingTime,
    this.serves,
    this.calories,
    this.hashtag,
    this.role,
    this.totalComment,
    this.totalReact,
    this.isReacted,
    this.isSaved,
    this.status,
    this.manyToManyRecipeCategories,
    this.recipeIngredients,
    // this.recipeImages,
    // this.recipeMethods,
  );
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      json["id"],
      json["userId"],
      json["name"],
      json['userImageUrl'],
      json["originId"],
      json["originName"],
      json["cookingMethodId"],
      json["cookingMethodName"],
      json["recipeName"],
      json['createDate'],
      json["description"],
      json["thumbnail"],
      json["preparationTime"],
      json["cookingTime"],
      json["serves"],
      json['calories'],
      json["hashtag"],
      json["role"],
      json["totalComment"],
      json["totalReact"],
      json["isReacted"],
      json["isSaved"],
      json["status"],
      (List<dynamic>.from(json["manyToManyRecipeCategories"]))
          .map((e) => RecipeCategories.fromJson(e))
          .toList(),
      (List<dynamic>.from(json["recipeIngredients"]))
          .map((e) => Ingredient.fromJson(e))
          .toList(),
      // (List<dynamic>.from(json["recipeImages"]))
      //     .map((e) => RecipeImages.fromJson(e))
      //     .toList(),
      // (List<dynamic>.from(json["recipeMethods"]))
      //     .map((e) => Method.fromJson(e))
      //     .toList(),
    );
  }
}

class RecipeCategories {
  final String recipeCategoryId;
  final String recipeCategoryName;
  RecipeCategories(this.recipeCategoryId, this.recipeCategoryName);
  factory RecipeCategories.fromJson(Map<String, dynamic> json) {
    return RecipeCategories(
      json["recipeCategoryId"],
      json["recipeCategoryName"],
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

// class Method {
//   final int step;
//   final String content;
//   final int status;
//   final List<RecipeMethodImg> recipeMethodImages;

//   Method(
//     this.step,
//     this.content,
//     this.status,
//     this.recipeMethodImages,
//   );
//   factory Method.fromJson(Map<String, dynamic> json) {
//     return Method(
//       json["step"],
//       json["content"],
//       json["status"],
//       (List<dynamic>.from(json["recipeMethodImages"]))
//           .map((e) => RecipeMethodImg.fromJson(e))
//           .toList(),
//     );
//   }
// }

// class RecipeMethodImg {
//   final int orderNumber;
//   final String imageUrl;
//   final int status;
//   RecipeMethodImg(this.orderNumber, this.imageUrl, this.status);
//   factory RecipeMethodImg.fromJson(Map<String, dynamic> json) {
//     return RecipeMethodImg(
//       json["orderNumber"],
//       json["imageUrl"],
//       json["status"],
//     );
//   }
// }

// class RecipeImages {
//   final int step;
//   final String content;
//   final int status;
//   final List<RecipeMethodImg> recipeMethodImages;

//   RecipeImages(
//     this.step,
//     this.content,
//     this.status,
//     this.recipeMethodImages,
//   );
//   factory RecipeImages.fromJson(Map<String, dynamic> json) {
//     return RecipeImages(
//       json["step"],
//       json["content"],
//       json["status"],
//       (List<dynamic>.from(json["recipeMethodImages"]))
//           .map((e) => RecipeMethodImg.fromJson(e))
//           .toList(),
//     );
//   }
// }
