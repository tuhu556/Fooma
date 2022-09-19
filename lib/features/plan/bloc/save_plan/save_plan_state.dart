part of 'save_plan_bloc.dart';

@immutable
class SavePlanState extends Equatable {
  final SavePlanStatus status;
  Map<String, dynamic> createPostParameters = {};
  ServerError? error;
  SavePlanState({required this.status});
  @override
  List<Object> get props => [status];
  SavePlanState copyWith(SavePlanStatus? status, ServerError? error) {
    var newState = SavePlanState(status: status ?? this.status);

    newState.createPostParameters = createPostParameters;

    if (error != null) {
      newState.error = error;
    }

    return newState;
  }
}

enum SavePlanStatus {
  Initial,
  Processing,
  Success,
  Failed,
}
