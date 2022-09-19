part of 'create_plan_bloc.dart';

@immutable
class CreatePlanEvent extends Equatable {
  const CreatePlanEvent();

  @override
  List<Object> get props => [];
}

class CreatePlan extends CreatePlanEvent {
  String recipeId;
  String plannedDate;
  int planCategory;
  bool isCompleted;
  int serve;
  CreatePlan(this.recipeId, this.plannedDate, this.planCategory,
      this.isCompleted, this.serve);
}

class CreatePlanSucces extends CreatePlanEvent {
  const CreatePlanSucces();
}

class CreatePlanFailed extends CreatePlanEvent {
  final ServerError error;
  const CreatePlanFailed(this.error);
}
