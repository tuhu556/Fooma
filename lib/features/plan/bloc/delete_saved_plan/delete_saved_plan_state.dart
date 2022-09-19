part of 'delete_saved_plan_bloc.dart';

@immutable
class DeleteSavedPlanState extends Equatable {
  final DeletePlanStatus status;
  Map<String, dynamic> createIngredientParameters = {};
  ServerError? error;
  DeleteSavedPlanState({required this.status});

  @override
  List<Object> get props => [status];
  DeleteSavedPlanState copyWith(DeletePlanStatus? status, ServerError? error) {
    var newState = DeleteSavedPlanState(status: status ?? this.status);

    newState.createIngredientParameters = createIngredientParameters;

    if (error != null) {
      newState.error = error;
    }

    return newState;
  }
}

enum DeletePlanStatus {
  Initial,
  Processing,
  Success,
  Failed,
}
