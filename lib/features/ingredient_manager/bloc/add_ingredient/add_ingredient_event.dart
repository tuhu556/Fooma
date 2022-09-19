part of 'add_ingredient_bloc.dart';

@immutable
class AddIngredientEvent extends Equatable {
  const AddIngredientEvent();

  @override
  List<Object> get props => [];
}

class CreateIngredientEvent extends AddIngredientEvent {
  String ingredientDbid;
  String categoryId;
  String ingredientName;
  String expiredDate;
  double quantity;
  String desciption;
  String imageUrl;
  String unit;
  String locationName;
  String locationId;
  List<IngredientNotifications>? ingredientNotifications;
  CreateIngredientEvent({
    required this.ingredientDbid,
    required this.categoryId,
    required this.ingredientName,
    required this.expiredDate,
    required this.quantity,
    required this.desciption,
    required this.imageUrl,
    required this.unit,
    required this.locationId,
    required this.locationName,
    this.ingredientNotifications,
  });
}

class AddIngredientSuccess extends AddIngredientEvent {
  const AddIngredientSuccess();
}

class AddIngredientFailed extends AddIngredientEvent {
  final ServerError error;
  const AddIngredientFailed(this.error);
}
