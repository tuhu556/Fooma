part of 'update_ingredient_bloc.dart';

@immutable
class UpdateIngredientState extends Equatable {
  final UpdateIngredientStatus status;
  Map<String, dynamic> createIngredientParameters = {};
  ServerError? error;
  UpdateIngredientState({required this.status});

  @override
  List<Object> get props => [status];
  UpdateIngredientState copyWith(
      UpdateIngredientStatus? status, ServerError? error) {
    var newState = UpdateIngredientState(status: status ?? this.status);

    newState.createIngredientParameters = createIngredientParameters;

    if (error != null) {
      newState.error = error;
    }

    return newState;
  }
}

enum UpdateIngredientStatus {
  Initial,
  Processing,
  Success,
  NothingChange,
  Failed,
}
