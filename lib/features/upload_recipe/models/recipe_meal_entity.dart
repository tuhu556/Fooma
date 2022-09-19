class RecipeMealResponse {
  List<RecipeMeal> recipeMeal;
  RecipeMealResponse(this.recipeMeal);

  factory RecipeMealResponse.fromJson(Map<String, dynamic> json) {
    final recipeOrigin =
        (json["items"] as List).map((e) => RecipeMeal.fromJson(e)).toList();
    return RecipeMealResponse(recipeOrigin);
  }
}

class RecipeMeal {
  final String id;
  final String recipeCategoryName;
  final int status;

  RecipeMeal(
    this.id,
    this.recipeCategoryName,
    this.status,
  );
  factory RecipeMeal.fromJson(Map<String, dynamic> json) {
    return RecipeMeal(
      json["id"],
      json["recipeCategoryName"],
      json["status"],
    );
  }
}
