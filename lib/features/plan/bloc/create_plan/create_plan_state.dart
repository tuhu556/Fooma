part of 'create_plan_bloc.dart';

@immutable
class CreatePlanState extends Equatable {
  final CreatePlanStatus status;
  Map<String, dynamic> createPlanParameters = {};
  ServerError? error;
  CreatePlanState({required this.status});

  @override
  List<Object> get props => [status];
  CreatePlanState copyWith(CreatePlanStatus? status, ServerError? error) {
    var newState = CreatePlanState(status: status ?? this.status);

    newState.createPlanParameters = createPlanParameters;

    if (error != null) {
      newState.error = error;
    }

    return newState;
  }
}

enum CreatePlanStatus {
  Initial,
  Processing,
  Success,
  Failed,
}
