class Recipe {
  String? recipeName;
  String? imagePath;
  int? time;
  double? calories;
  bool? isSave;
  Recipe(
      this.recipeName, this.imagePath, this.time, this.calories, this.isSave);
}

List<Recipe> savedRecipe = [
  Recipe("Hot and Prawn Noodlesssssssss ciofdghbsdfvs sdfsdf",
      "assets/images/hambuger.png", 54, 200, false),
  Recipe("Hot and Prawn", "assets/images/hambuger.png", 30, 200, false),
  Recipe("Hot and Prawn ", "assets/images/hambuger.png", 30, 200, false),
  Recipe("Hot and Prawn ", "assets/images/hambuger.png", 30, 200, false),
  Recipe("Hot and Prawn Noodlesssssssss", "assets/images/hambuger.png", 30, 200,
      false),
  Recipe("Hot and Prawn Noodlesssssssss", "assets/images/hambuger.png", 30, 200,
      false),
  Recipe("Hot and Prawn Noodlesssssssss", "assets/images/hambuger.png", 30, 200,
      false),
];
