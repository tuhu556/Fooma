class MethodRecipeResponse {
  List<Method> method;
  MethodRecipeResponse(this.method);

  factory MethodRecipeResponse.fromJson(Map<String, dynamic> json) {
    final listMethod =
        (json["recipeMethods"] as List).map((e) => Method.fromJson(e)).toList();
    return MethodRecipeResponse(listMethod);
  }
}

class Method {
  final int step;
  final String content;
  final int status;
  final List<RecipeMethodImg> recipeMethodImages;

  Method(
    this.step,
    this.content,
    this.status,
    this.recipeMethodImages,
  );
  factory Method.fromJson(Map<String, dynamic> json) {
    return Method(
      json["step"],
      json["content"],
      json["status"],
      (List<dynamic>.from(json["recipeMethodImages"]))
          .map((e) => RecipeMethodImg.fromJson(e))
          .toList(),
    );
  }
}

class RecipeMethodImg {
  final int orderNumber;
  final String imageUrl;
  final int status;
  RecipeMethodImg(this.orderNumber, this.imageUrl, this.status);
  factory RecipeMethodImg.fromJson(Map<String, dynamic> json) {
    return RecipeMethodImg(
      json["orderNumber"],
      json["imageUrl"],
      json["status"],
    );
  }
}
