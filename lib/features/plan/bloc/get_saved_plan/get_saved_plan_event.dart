part of 'get_saved_plan_bloc.dart';

@immutable
class GetSavedPlanEvent extends Equatable {
  const GetSavedPlanEvent();

  @override
  List<Object> get props => [];
}

class GetSavedPlan extends GetSavedPlanEvent {
  final int page;
  final int size;
  final String sortOption;
  final String date;
  const GetSavedPlan(this.page, this.size, this.sortOption, this.date);
}

class GetPlanSuccess extends GetSavedPlanEvent {
  final PlanPrepareResponse data;
  const GetPlanSuccess(this.data);
}

class GetPlanFailed extends GetSavedPlanEvent {
  final ServerError error;
  const GetPlanFailed(this.error);
}
