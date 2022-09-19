class CalculatedIngredientModel {
  final String ingredientDbId;
  final String ingredientName;
  final double quantity;
  final String unit;
  final double quantityUser;
  final String unitUser;
  CalculatedIngredientModel(this.ingredientDbId, this.ingredientName,
      this.quantity, this.unit, this.quantityUser, this.unitUser);
}
