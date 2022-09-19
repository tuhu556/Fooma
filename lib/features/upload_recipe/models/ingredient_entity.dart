class IngredientResponse {
  List<Ingredient> listIngredient;
  IngredientResponse(this.listIngredient);

  factory IngredientResponse.fromJson(Map<String, dynamic> json) {
    final listIngredient =
        (json["items"] as List).map((e) => Ingredient.fromJson(e)).toList();
    return IngredientResponse(listIngredient);
  }
}

class Ingredient {
  final String id;
  final String categoryId;
  final String ingredientName;
  final String createDate;
  final String imageUrl;
  final String unit;
  final int status;
  final String categoryName;

  Ingredient(
    this.id,
    this.categoryId,
    this.ingredientName,
    this.createDate,
    this.imageUrl,
    this.unit,
    this.status,
    this.categoryName,
  );
  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      json["id"],
      json["categoryId"],
      json["ingredientName"],
      json["createDate"],
      json["imageUrl"],
      json["unit"],
      json["status"],
      json["categoryName"],
    );
  }
}
