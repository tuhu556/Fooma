part of 'delete_saved_plan_bloc.dart';

@immutable
class DeleteSavedPlanEvent extends Equatable {
  const DeleteSavedPlanEvent();

  @override
  List<Object> get props => [];
}

class DeletePlan extends DeleteSavedPlanEvent {
  String id;

  DeletePlan({required this.id});
}

class DeletePlanSuccess extends DeleteSavedPlanEvent {
  const DeletePlanSuccess();
}

class DeletePlanFailed extends DeleteSavedPlanEvent {
  final ServerError error;
  const DeletePlanFailed(this.error);
}
