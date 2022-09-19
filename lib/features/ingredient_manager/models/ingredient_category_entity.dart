class IngredientCategoryResponse {
  int totalItem;
  List<IngredientCategoryModel> item;
  IngredientCategoryResponse(this.totalItem, this.item);
  factory IngredientCategoryResponse.fromJson(Map<String, dynamic> json) {
    final totalItem = json["totalItem"];
    final items = (json["items"] as List)
        .map((e) => IngredientCategoryModel.fromJson(e))
        .toList();

    return IngredientCategoryResponse(totalItem, items);
  }
}

class IngredientCategoryModel {
  final String categoryId;
  final String categoryName;
  IngredientCategoryModel(this.categoryId, this.categoryName);
  factory IngredientCategoryModel.fromJson(Map<String, dynamic> json) {
    return IngredientCategoryModel(
      json["id"],
      json["categoryName"],
    );
  }
}
