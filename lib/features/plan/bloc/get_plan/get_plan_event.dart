part of 'get_plan_bloc.dart';

@immutable
class GetPlanEvent extends Equatable {
  const GetPlanEvent();

  @override
  List<Object> get props => [];
}

class Plan extends GetPlanEvent {
  final int page;
  final int size;
  final String sortOption;
  final String date;
  const Plan(this.page, this.size, this.sortOption, this.date);
}

class GetPlanSuccess extends GetPlanEvent {
  final PlanResponse data;
  const GetPlanSuccess(this.data);
}

class GetPlanFailed extends GetPlanEvent {
  final ServerError error;
  const GetPlanFailed(this.error);
}
