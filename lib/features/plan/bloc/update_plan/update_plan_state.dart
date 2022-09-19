part of 'update_plan_bloc.dart';

@immutable
class UpdatePlanState extends Equatable {
  final UpdatePlanStatus status;
  Map<String, dynamic> createPlanParameters = {};
  ServerError? error;
  UpdatePlanState({required this.status});
  @override
  List<Object> get props => [status];
  UpdatePlanState copyWith(UpdatePlanStatus? status, ServerError? error) {
    var newState = UpdatePlanState(status: status ?? this.status);

    newState.createPlanParameters = createPlanParameters;

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
