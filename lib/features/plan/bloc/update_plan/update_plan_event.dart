part of 'update_plan_bloc.dart';

@immutable
class UpdatePlanEvent extends Equatable {
  const UpdatePlanEvent();

  @override
  List<Object> get props => [];
}

class CreateUpdatePlanEvent extends UpdatePlanEvent {
  String planId;

  String recipeId;
  String plannedDate;
  int planCategory;
  bool isCompleted;
  int serve;
  CreateUpdatePlanEvent({
    required this.planId,
    required this.recipeId,
    required this.plannedDate,
    required this.planCategory,
    required this.isCompleted,
    required this.serve,
  });
}

class UpdatePlanSuccess extends UpdatePlanEvent {
  const UpdatePlanSuccess();
}

class UpdatePlanFailed extends UpdatePlanEvent {
  final ServerError error;
  const UpdatePlanFailed(this.error);
}
