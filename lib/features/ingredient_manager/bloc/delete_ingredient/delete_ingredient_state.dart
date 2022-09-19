part of 'delete_ingredient_bloc.dart';

@immutable
class DeleteIngredientState extends Equatable {
  final DeleteIngredientStatus status;
  Map<String, dynamic> createIngredientParameters = {};
  ServerError? error;
  DeleteIngredientState({required this.status});

  @override
  List<Object> get props => [status];
  DeleteIngredientState copyWith(
      DeleteIngredientStatus? status, ServerError? error) {
    var newState = DeleteIngredientState(status: status ?? this.status);

    newState.createIngredientParameters = createIngredientParameters;

    if (error != null) {
      newState.error = error;
    }

    return newState;
  }
}

enum DeleteIngredientStatus {
  Initial,
  Processing,
  Success,
  Failed,
}
