class CategoryRecipeResponse {
  final int page;
  final int size;
  final int totalItem;
  final int totalPage;
  final List<RecipeCategoryModel> items;
  CategoryRecipeResponse(
      this.page, this.size, this.totalItem, this.totalPage, this.items);
  factory CategoryRecipeResponse.fromJson(Map<String, dynamic> json) {
    final page = json["page"];
    final size = json["size"];
    final totalItem = json["totalItem"];
    final totalPage = json["totalPage"];
    final items = (json["items"] as List)
        .map((e) => RecipeCategoryModel.fromJson(e))
        .toList();

    return CategoryRecipeResponse(page, size, totalItem, totalPage, items);
  }
}

class RecipeCategoryModel {
  final String id;
  final String categoryName;
  RecipeCategoryModel(this.id, this.categoryName);
  factory RecipeCategoryModel.fromJson(Map<String, dynamic> json) {
    return RecipeCategoryModel(
      json["id"],
      json["recipeCategoryName"],
    );
  }
}
