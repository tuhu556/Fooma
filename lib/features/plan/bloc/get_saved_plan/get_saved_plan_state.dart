part of 'get_saved_plan_bloc.dart';

@immutable
class GetSavedPlanState extends Equatable {
  final PlanStatus status;
  PlanPrepareResponse? planResponse;
  PlanPrepareModel? planData;
  ServerError? error;
  GetSavedPlanState({required this.status, this.planData});
  @override
  List<Object> get props => [status];
  GetSavedPlanState copyWith(
    PlanStatus? status,
    PlanPrepareResponse? planResponse,
    PlanPrepareModel? planData,
    ServerError? error,
  ) {
    var newState = GetSavedPlanState(status: status ?? this.status);

    if (planResponse != null) {
      newState.planResponse = planResponse;
    }
    if (planData != null) {
      newState.planData = planData;
    }

    if (error != null) {
      newState.error = error;
    }

    return newState;
  }
}

enum PlanStatus {
  Initial,
  Processing,
  Success,
  Failed,
}
