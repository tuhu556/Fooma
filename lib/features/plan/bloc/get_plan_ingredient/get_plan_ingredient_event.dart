part of 'get_plan_ingredient_bloc.dart';

@immutable
class GetPlanIngredientEvent extends Equatable {
  const GetPlanIngredientEvent();

  @override
  List<Object> get props => [];
}

class GetPlanIngredient extends GetPlanIngredientEvent {
  final String selectedDate;
  const GetPlanIngredient(this.selectedDate);
}

class GetPlanIngredientSuccess extends GetPlanIngredientEvent {
  final PlanIngredientResponse data;
  const GetPlanIngredientSuccess(this.data);
}

class GetPlanIngredientFailed extends GetPlanIngredientEvent {
  final ServerError error;
  const GetPlanIngredientFailed(this.error);
}
