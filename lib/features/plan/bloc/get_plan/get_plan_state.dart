part of 'get_plan_bloc.dart';

@immutable
class GetPlanState extends Equatable {
  final PlanStatus status;
  PlanResponse? planResponse;
  PlanModel? planData;
  ServerError? error;
  GetPlanState({required this.status, this.planData});
  @override
  List<Object> get props => [status];
  GetPlanState copyWith(
    PlanStatus? status,
    PlanResponse? planResponse,
    PlanModel? planData,
    ServerError? error,
  ) {
    var newState = GetPlanState(status: status ?? this.status);

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
