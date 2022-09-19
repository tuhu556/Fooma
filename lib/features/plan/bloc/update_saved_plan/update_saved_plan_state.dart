part of 'update_saved_plan_bloc.dart';

@immutable
class UpdateSavedPlanState extends Equatable {
  final UpdatePlanStatus status;
  Map<String, dynamic> createIngredientParameters = {};
  ServerError? error;
  UpdateSavedPlanState({required this.status});

  @override
  List<Object> get props => [status];
  UpdateSavedPlanState copyWith(UpdatePlanStatus? status, ServerError? error) {
    var newState = UpdateSavedPlanState(status: status ?? this.status);

    newState.createIngredientParameters = createIngredientParameters;

    if (error != null) {
      newState.error = error;
    }

    return newState;
  }
}

enum UpdatePlanStatus {
  Initial,
  Processing,
  Success,
  Failed,
}
