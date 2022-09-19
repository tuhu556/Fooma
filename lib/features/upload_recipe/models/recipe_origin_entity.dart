class RecipeOriginResponse {
  List<RecipeOrigin> recipeOrigin;
  RecipeOriginResponse(this.recipeOrigin);

  factory RecipeOriginResponse.fromJson(Map<String, dynamic> json) {
    final recipeOrigin =
        (json["items"] as List).map((e) => RecipeOrigin.fromJson(e)).toList();
    return RecipeOriginResponse(recipeOrigin);
  }
}

class RecipeOrigin {
  final String id;
  final String originName;
  final int status;

  RecipeOrigin(
    this.id,
    this.originName,
    this.status,
  );
  factory RecipeOrigin.fromJson(Map<String, dynamic> json) {
    return RecipeOrigin(
      json["id"],
      json["originName"],
      json["status"],
    );
  }
}
