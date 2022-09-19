class RecipeAppResponse {
  final int page;
  final int size;
  final int totalItem;
  final int totalPage;
  final List<RecipeAppModel> items;
  RecipeAppResponse(
      this.page, this.size, this.totalItem, this.totalPage, this.items);

  factory RecipeAppResponse.fromJson(Map<String, dynamic> json) {
    final page = json["page"];
    final size = json["size"];
    final totalItem = json["totalItem"];
    final totalPage = json["totalPage"];
    final items =
        (json["items"] as List).map((e) => RecipeAppModel.fromJson(e)).toList();
    return RecipeAppResponse(page, size, totalItem, totalPage, items);
  }
}

class RecipeAppModel {
  final String id;
  final String originId;
  final String originName;
  final String cookingMethodId;
  final String cookingMethodName;
  final String recipeName;
  final String createDate;
  final String publishDate;
  final String description;
  final String thumbnailImage;
  final int preparationTime;
  final int cookingTime;
  final int serves;
  final double calories;
  final int totalRating;
  final double totalRatingPoint;
  final bool isRated;
  bool isSaved;
  final List<RecipeCategoryAppModel> categoryModelList;
  final List<RecipeIngredientAppModel> ingredientModelList;
  RecipeAppModel(
    this.id,
    this.originId,
    this.originName,
    this.cookingMethodId,
    this.cookingMethodName,
    this.recipeName,
    this.createDate,
    this.publishDate,
    this.description,
    this.thumbnailImage,
    this.preparationTime,
    this.cookingTime,
    this.serves,
    this.calories,
    this.totalRating,
    this.totalRatingPoint,
    this.isRated,
    this.isSaved,
    this.categoryModelList,
    this.ingredientModelList,
  );

  factory RecipeAppModel.fromJson(Map<String, dynamic> json) {
    final id = json["id"];
    final originId = json["originId"];
    final originName = json["originName"];
    final cookingMethodId = json["cookingMethodId"];
    final cookingMethodName = json["cookingMethodName"];
    final recipeName = json["recipeName"];
    final createDate = json["createDate"];
    final publishDate = json["publishedDate"];
    final description = json["description"];
    final thumbnailImage = json["thumbnail"];
    final preparationTime = json["preparationTime"];
    final cookingTime = json["cookingTime"];
    final serves = json["serves"];
    final calories = json["calories"];
    final totalRating = json["totalRating"];
    final totalRatingPoint = json["totalRatingPoint"];
    final isRated = json["isRated"];
    final isSaved = json["isSaved"];
    final categoryModelList =
        (List<dynamic>.from(json["manyToManyRecipeCategories"]))
            .map((e) => RecipeCategoryAppModel.fromJson(e))
            .toList();
    final ingredientModelList = (List<dynamic>.from(json["recipeIngredients"]))
        .map((e) => RecipeIngredientAppModel.fromJson(e))
        .toList();

    return RecipeAppModel(
        id,
        originId,
        originName,
        cookingMethodId,
        cookingMethodName,
        recipeName,
        createDate,
        publishDate,
        description,
        thumbnailImage,
        preparationTime,
        cookingTime,
        serves,
        calories,
        totalRating,
        totalRatingPoint,
        isRated,
        isSaved,
        categoryModelList,
        ingredientModelList);
  }
}

class RecipeCategoryAppModel {
  final String recipeCategoryId;
  final String recipeCategoryName;
  RecipeCategoryAppModel(this.recipeCategoryId, this.recipeCategoryName);
  factory RecipeCategoryAppModel.fromJson(Map<String, dynamic> json) {
    return RecipeCategoryAppModel(
      json["recipeCategoryId"],
      json["recipeCategoryName"],
    );
  }
}

class RecipeIngredientAppModel {
  final String recipeIngredientDBid;
  final String ingredientName;
  final double quantity;
  final String unit;
  final bool isMain;
  RecipeIngredientAppModel(this.recipeIngredientDBid, this.ingredientName,
      this.quantity, this.unit, this.isMain);
  factory RecipeIngredientAppModel.fromJson(Map<String, dynamic> json) {
    return RecipeIngredientAppModel(json["ingredientDbid"],
        json["ingredientName"], json["quantity"], json["unit"], json["isMain"]);
  }
}

class RecipeMethodAppModel {
  final int step;
  final String content;
  final List<RecipeMethodImagesAppModel> imageList;
  RecipeMethodAppModel(this.step, this.content, this.imageList);
  factory RecipeMethodAppModel.fromJson(Map<String, dynamic> json) {
    final step = json["step"];
    final content = json["content"];
    final imageList = (List<dynamic>.from(json["recipeMethodImages"]))
        .map((e) => RecipeMethodImagesAppModel.fromJson(e))
        .toList();
    return RecipeMethodAppModel(step, content, imageList);
  }
}

class RecipeMethodImagesAppModel {
  final int orderNumber;
  final String imageMethodUrl;
  RecipeMethodImagesAppModel(this.orderNumber, this.imageMethodUrl);
  factory RecipeMethodImagesAppModel.fromJson(Map<String, dynamic> json) {
    return RecipeMethodImagesAppModel(json["orderNumber"], json["imageUrl"]);
  }
}

// this model is for recipe's detail
class RecipeDetailAppModel {
  final String id;
  final String originId;
  final String originName;
  final String cookingMethodId;
  final String cookingMethodName;
  final String recipeName;
  final String createDate;
  final String publishDate;
  final String description;
  final String thumbnailImage;
  final int preparationTime;
  final int cookingTime;
  final int serves;
  final double calories;
  final int totalRating;
  final double totalRatingPoint;
  final bool isRated;
  bool isSaved;
  final List<RecipeCategoryAppModel> categoryModelList;
  final List<RecipeIngredientAppModel> ingredientModelList;
  final List<RecipeMethodAppModel> methodList;
  RecipeDetailAppModel(
      this.id,
      this.originId,
      this.originName,
      this.cookingMethodId,
      this.cookingMethodName,
      this.recipeName,
      this.createDate,
      this.publishDate,
      this.description,
      this.thumbnailImage,
      this.preparationTime,
      this.cookingTime,
      this.serves,
      this.calories,
      this.totalRating,
      this.totalRatingPoint,
      this.isRated,
      this.isSaved,
      this.categoryModelList,
      this.ingredientModelList,
      this.methodList);

  factory RecipeDetailAppModel.fromJson(Map<String, dynamic> json) {
    final id = json["id"];
    final originId = json["originId"];
    final originName = json["originName"];
    final cookingMethodId = json["cookingMethodId"];
    final cookingMethodName = json["cookingMethodName"];
    final recipeName = json["recipeName"];
    final createDate = json["createDate"];
    final publishDate = json["publishedDate"];
    final description = json["description"];
    final thumbnailImage = json["thumbnail"];
    final preparationTime = json["preparationTime"];
    final cookingTime = json["cookingTime"];
    final serves = json["serves"];
    final calories = json["calories"];
    final totalRating = json["totalRating"];
    final totalRatingPoint = json["totalRatingPoint"];
    final isRated = json["isRated"];
    final isSaved = json["isSaved"];
    final categoryModelList =
        (List<dynamic>.from(json["manyToManyRecipeCategories"]))
            .map((e) => RecipeCategoryAppModel.fromJson(e))
            .toList();
    final ingredientModelList = (List<dynamic>.from(json["recipeIngredients"]))
        .map((e) => RecipeIngredientAppModel.fromJson(e))
        .toList();
    final methodList = (List<dynamic>.from(json["recipeMethods"]))
        .map((e) => RecipeMethodAppModel.fromJson(e))
        .toList();

    return RecipeDetailAppModel(
        id,
        originId,
        originName,
        cookingMethodId,
        cookingMethodName,
        recipeName,
        createDate,
        publishDate,
        description,
        thumbnailImage,
        preparationTime,
        cookingTime,
        serves,
        calories,
        totalRating,
        totalRatingPoint,
        isRated,
        isSaved,
        categoryModelList,
        ingredientModelList,
        methodList);
  }
}
