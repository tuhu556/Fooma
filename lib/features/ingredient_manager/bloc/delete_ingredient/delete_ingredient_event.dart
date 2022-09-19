part of 'delete_ingredient_bloc.dart';

@immutable
class DeleteIngredientEvent extends Equatable {
  const DeleteIngredientEvent();

  @override
  List<Object> get props => [];
}

class CreateDeleteIngredientEvent extends DeleteIngredientEvent {
  String id;

  CreateDeleteIngredientEvent({required this.id});
}

class DeleteIngredientSuccess extends DeleteIngredientEvent {
  const DeleteIngredientSuccess();
}

class DeleteIngredientFailed extends DeleteIngredientEvent {
  final ServerError error;
  const DeleteIngredientFailed(this.error);
}
