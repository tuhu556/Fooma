class PlanResponse {
  int totalItem;
  List<PlanModel> items;
  PlanResponse(this.totalItem, this.items);
  factory PlanResponse.fromJson(Map<String, dynamic> json) {
    final totalItem = json["totalItem"];
    final items =
        (json["items"] as List).map((e) => PlanModel.fromJson(e)).toList();

    return PlanResponse(totalItem, items);
  }
}

class PlanModel {
  final String planId;
  final String userId;
  final String recipeId;
  final String recipeName;
  final String thumbnail;
  final String plannedDate;
  final String createDate;
  final int planCategory;
  bool isCompleted;

  final int serve;
  final List<PlanIngredientModel> planIngredient;
  bool onTap = false;
  PlanModel(
    this.planId,
    this.userId,
    this.recipeId,
    this.recipeName,
    this.thumbnail,
    this.plannedDate,
    this.createDate,
    this.planCategory,
    this.isCompleted,
    this.serve,
    this.planIngredient,
  );
  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      json["id"],
      json["userId"],
      json["recipeId"],
      json['recipeName'],
      json['thumbnail'],
      json["plannedDate"],
      json["createDate"],
      json["planCategory"],
      json["isCompleted"],
      json['serve'],
      (List<dynamic>.from(json["planIngredients"]))
          .map((e) => PlanIngredientModel.fromJson(e))
          .toList(),
    );
  }
}

class PlanIngredientResponse {
  final int totalItem;
  final List<PlanIngredientModel> items;
  PlanIngredientResponse(this.totalItem, this.items);
  factory PlanIngredientResponse.fromJson(Map<String, dynamic> json) {
    return PlanIngredientResponse(
      json["totalItem"],
      (List<dynamic>.from(json["items"]))
          .map((e) => PlanIngredientModel.fromJson(e))
          .toList(),
    );
  }
}

class PlanIngredientModel {
  final String ingredientDbId;
  final String ingredientName;
  final double quantity;
  final bool isMain;
  final String unit;
  PlanIngredientModel(this.ingredientDbId, this.ingredientName, this.quantity,
      this.isMain, this.unit);
  factory PlanIngredientModel.fromJson(Map<String, dynamic> json) {
    return PlanIngredientModel(
      json["ingredientDbId"],
      json["ingredientName"],
      json["quantity"],
      json['isMain'],
      json['unit'],
    );
  }
}
