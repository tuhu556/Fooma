part of 'delete_plan_bloc.dart';

@immutable
class DeletePlanEvent extends Equatable {
  const DeletePlanEvent();

  @override
  List<Object> get props => [];
}

class CreateDeletePlanEvent extends DeletePlanEvent {
  String id;

  CreateDeletePlanEvent({required this.id});
}

class DeletePlanSuccess extends DeletePlanEvent {
  const DeletePlanSuccess();
}

class DeletePlanFailed extends DeletePlanEvent {
  final ServerError error;
  const DeletePlanFailed(this.error);
}
