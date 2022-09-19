class RecipeProcessResponse {
  List<RecipeProcess> recipeProcess;
  RecipeProcessResponse(this.recipeProcess);

  factory RecipeProcessResponse.fromJson(Map<String, dynamic> json) {
    final recipeProcess =
        (json["items"] as List).map((e) => RecipeProcess.fromJson(e)).toList();
    return RecipeProcessResponse(recipeProcess);
  }
}

class RecipeProcess {
  final String id;
  final String cookingMethodName;
  final int status;

  RecipeProcess(
    this.id,
    this.cookingMethodName,
    this.status,
  );
  factory RecipeProcess.fromJson(Map<String, dynamic> json) {
    return RecipeProcess(
      json["id"],
      json["cookingMethodName"],
      json["status"],
    );
  }
}
