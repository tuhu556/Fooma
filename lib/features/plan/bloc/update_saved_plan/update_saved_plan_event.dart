part of 'update_saved_plan_bloc.dart';

@immutable
class UpdateSavedPlanEvent extends Equatable {
  const UpdateSavedPlanEvent();

  @override
  List<Object> get props => [];
}

class UpdateSavedPlan extends UpdateSavedPlanEvent {
  final String id;
  final String planDate;
  final List<IngredientPrepareModel> list;
  const UpdateSavedPlan(
      {required this.id, required this.planDate, required this.list});
}

class UpdateSavedPlanSuccess extends UpdateSavedPlanEvent {
  const UpdateSavedPlanSuccess();
}

class UpdateSavedPlanFailed extends UpdateSavedPlanEvent {
  final ServerError error;
  const UpdateSavedPlanFailed(this.error);
}
