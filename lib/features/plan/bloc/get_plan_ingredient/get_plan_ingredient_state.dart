part of 'get_plan_ingredient_bloc.dart';

@immutable
class GetPlanIngredientState extends Equatable {
  final PlanIngredientStatus status;
  PlanIngredientResponse? planIngredientResponse;
  PlanIngredientModel? planIngredientModel;
  ServerError? error;
  GetPlanIngredientState({required this.status, this.planIngredientModel});
  @override
  List<Object> get props => [status];
  GetPlanIngredientState copyWith(
    PlanIngredientStatus? status,
    PlanIngredientResponse? planIngredientResponse,
    PlanIngredientModel? planIngredientModel,
    ServerError? error,
  ) {
    var newState = GetPlanIngredientState(status: status ?? this.status);

    if (planIngredientResponse != null) {
      newState.planIngredientResponse = planIngredientResponse;
    }
    if (planIngredientModel != null) {
      newState.planIngredientModel = planIngredientModel;
    }

    if (error != null) {
      newState.error = error;
    }

    return newState;
  }
}

enum PlanIngredientStatus {
  Initial,
  Processing,
  Success,
  Failed,
}
