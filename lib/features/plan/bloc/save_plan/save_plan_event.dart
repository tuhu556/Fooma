part of 'save_plan_bloc.dart';

@immutable
class SavePlanEvent extends Equatable {
  const SavePlanEvent();

  @override
  List<Object> get props => [];
}

class SavePlan extends SavePlanEvent {
  String planDate;
  List<IngredientPrepareModel> list;
  SavePlan({required this.list, required this.planDate});
}

class SavePlanSuccess extends SavePlanEvent {
  const SavePlanSuccess();
}

class SavePlanFailed extends SavePlanEvent {
  final ServerError error;
  const SavePlanFailed(this.error);
}
