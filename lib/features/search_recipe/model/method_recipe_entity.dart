class MethodRecipeResponse {
  final int page;
  final int size;
  final int totalItem;
  final int totalPage;
  final List<MethodRecipeModel> items;
  MethodRecipeResponse(
      this.page, this.size, this.totalItem, this.totalPage, this.items);
  factory MethodRecipeResponse.fromJson(Map<String, dynamic> json) {
    final page = json["page"];
    final size = json["size"];
    final totalItem = json["totalItem"];
    final totalPage = json["totalPage"];
    final items = (json["items"] as List)
        .map((e) => MethodRecipeModel.fromJson(e))
        .toList();

    return MethodRecipeResponse(page, size, totalItem, totalPage, items);
  }
}

class MethodRecipeModel {
  final String id;
  late final String methodName;
  MethodRecipeModel(this.id, this.methodName);
  factory MethodRecipeModel.fromJson(Map<String, dynamic> json) {
    return MethodRecipeModel(
      json["id"],
      json["cookingMethodName"],
    );
  }
}
