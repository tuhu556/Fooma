class PlanPrepareResponse {
  final int page;
  final int size;
  final int totalItem;
  final List<PlanPrepareModel> planList;
  PlanPrepareResponse(this.page, this.size, this.totalItem, this.planList);
  factory PlanPrepareResponse.fromJson(Map<String, dynamic> json) {
    return PlanPrepareResponse(
      json["page"],
      json["size"],
      json["totalItem"],
      (List<dynamic>.from(json["items"]))
          .map((e) => PlanPrepareModel.fromJson(e))
          .toList(),
    );
  }
}

class PlanPrepareModel {
  final String id;
  final String planDate;
  final String createDate;
  final List<IngredientPrepareModel> ingredientList;
  PlanPrepareModel(
      this.id, this.planDate, this.createDate, this.ingredientList);

  factory PlanPrepareModel.fromJson(Map<String, dynamic> json) {
    return PlanPrepareModel(
      json["id"],
      json["planDate"],
      json["createDate"],
      (List<dynamic>.from(json["planPrepareIngredients"]))
          .map((e) => IngredientPrepareModel.fromJson(e))
          .toList(),
    );
  }
}

class IngredientPrepareModel {
  final String ingredientDbId;
  final String ingredientName;
  final String unit;
  final double quantity;
  bool isCheck;
  IngredientPrepareModel(this.ingredientDbId, this.ingredientName, this.unit,
      this.quantity, this.isCheck);
  factory IngredientPrepareModel.fromJson(Map<String, dynamic> json) {
    return IngredientPrepareModel(
      json["ingredientDbId"],
      json["ingredientName"],
      json["unit"],
      json["quantity"],
      json["isCheck"],
    );
  }
}
