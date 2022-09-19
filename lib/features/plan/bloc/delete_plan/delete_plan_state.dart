part of 'delete_plan_bloc.dart';

@immutable
class DeletePlanState extends Equatable {
  final DeletePlanStatus status;
  Map<String, dynamic> createDeletePlanParameters = {};
  ServerError? error;
  DeletePlanState({required this.status});

  @override
  List<Object> get props => [status];
  DeletePlanState copyWith(DeletePlanStatus? status, ServerError? error) {
    var newState = DeletePlanState(status: status ?? this.status);

    newState.createDeletePlanParameters = createDeletePlanParameters;

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
