part of 'add_ingredient_bloc.dart';

@immutable
class AddIngredientState extends Equatable {
  final AddIngredientStatus status;
  Map<String, dynamic> createIngredientParameters = {};
  ServerError? error;
  AddIngredientState({required this.status});

  @override
  List<Object> get props => [status];
  AddIngredientState copyWith(AddIngredientStatus? status, ServerError? error) {
    var newState = AddIngredientState(status: status ?? this.status);

    newState.createIngredientParameters = createIngredientParameters;

    if (error != null) {
      newState.error = error;
    }

    return newState;
  }
}

enum AddIngredientStatus {
  Initial,
  Processing,
  Success,
  Failed,
}
