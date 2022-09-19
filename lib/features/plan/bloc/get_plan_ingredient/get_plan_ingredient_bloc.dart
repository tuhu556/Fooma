import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodhub/features/plan/models/plan_entity.dart';
import 'package:foodhub/features/plan/repository/get_plan_ingredient.dart';
import 'package:foodhub/service/networking.dart';

part 'get_plan_ingredient_event.dart';
part 'get_plan_ingredient_state.dart';

class GetPlanIngredientBloc
    extends Bloc<GetPlanIngredientEvent, GetPlanIngredientState> {
  GetPlanIngredientBloc()
      : super(GetPlanIngredientState(status: PlanIngredientStatus.Initial));
  @override
  Stream<GetPlanIngredientState> mapEventToState(
    GetPlanIngredientEvent event,
  ) async* {
    if (event is GetPlanIngredient) {
      yield state.copyWith(PlanIngredientStatus.Processing, null, null, null);
      yield* _mapGetPlanIngredientToState(event);
    } else if (event is GetPlanIngredientSuccess) {
      yield state.copyWith(
          PlanIngredientStatus.Success, event.data, null, null);
    } else if (event is GetPlanIngredientFailed) {
      yield state.copyWith(
          PlanIngredientStatus.Failed, null, null, event.error);
    }
  }

  Stream<GetPlanIngredientState> _mapGetPlanIngredientToState(
      GetPlanIngredient event) async* {
    final repository = GetPlanIngredientRepository();

    try {
      repository.getPlanIngridentData(event.selectedDate, (value) {
        if (value is PlanIngredientResponse) {
          add(GetPlanIngredientSuccess(value));
        } else {
          add(GetPlanIngredientFailed(value as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(
          PlanIngredientStatus.Failed, null, null, ServerError.internalError());
    }
  }
}
