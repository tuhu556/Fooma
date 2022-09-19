part of 'update_ingredient_bloc.dart';

@immutable
class UpdateIngredientEvent extends Equatable {
  const UpdateIngredientEvent();

  @override
  List<Object> get props => [];
}

class CreateUpdateIngredientEvent extends UpdateIngredientEvent {
  String ingredientId;
  List<IngredientNotifications> ingredientNotifications;
  String ingredientName;
  String categoryId;
  String expiredDate;
  double quantity;
  String desciption;
  String imageUrl;
  String unit;
  String locationId;
  String locationName;
  CreateUpdateIngredientEvent({
    required this.ingredientId,
    required this.ingredientNotifications,
    required this.ingredientName,
    required this.categoryId,
    required this.expiredDate,
    required this.quantity,
    required this.desciption,
    required this.imageUrl,
    required this.unit,
    required this.locationId,
    required this.locationName,
  });
}

class UpdateIngredientSuccess extends UpdateIngredientEvent {
  const UpdateIngredientSuccess();
}

class UpdateIngredientNothing extends UpdateIngredientEvent {
  const UpdateIngredientNothing();
}

class UpdateIngredientFailed extends UpdateIngredientEvent {
  final ServerError error;
  const UpdateIngredientFailed(this.error);
}
