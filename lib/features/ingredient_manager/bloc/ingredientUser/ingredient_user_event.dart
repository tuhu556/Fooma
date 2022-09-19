part of 'ingredient_user_bloc.dart';

@immutable
class IngredientUserEvent extends Equatable {
  const IngredientUserEvent();

  @override
  List<Object> get props => [];
}

class IngredientUser extends IngredientUserEvent {
  final String sortOption;
  final String condition;
  final String entityName;
  final String locationName;
  const IngredientUser(
      this.sortOption, this.condition, this.entityName, this.locationName);
}

class GetIngredientUserSuccess extends IngredientUserEvent {
  final IngredientUserResponse data;
  const GetIngredientUserSuccess(this.data);
}

class GetIngredientUserFailed extends IngredientUserEvent {
  final ServerError error;
  const GetIngredientUserFailed(this.error);
}
