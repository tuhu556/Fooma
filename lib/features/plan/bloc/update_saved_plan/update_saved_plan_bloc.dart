import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodhub/features/plan/models/ingredientPrepare_entity.dart';
import 'package:foodhub/features/plan/repository/update_saved_plan_repository.dart';
import 'package:foodhub/service/networking.dart';

part 'update_saved_plan_event.dart';
part 'update_saved_plan_state.dart';

class UpdateSavedPlanBloc
    extends Bloc<UpdateSavedPlanEvent, UpdateSavedPlanState> {
  UpdateSavedPlanBloc()
      : super(UpdateSavedPlanState(status: UpdatePlanStatus.Initial));
  @override
  Stream<UpdateSavedPlanState> mapEventToState(
    UpdateSavedPlanEvent event,
  ) async* {
    if (event is UpdateSavedPlan) {
      yield state.copyWith(UpdatePlanStatus.Processing, null);
      yield* _mapPlanState(event);
    } else if (event is UpdateSavedPlanSuccess) {
      yield state.copyWith(UpdatePlanStatus.Success, null);
    } else if (event is UpdateSavedPlanFailed) {
      yield state.copyWith(UpdatePlanStatus.Failed, event.error);
    }
  }

  Stream<UpdateSavedPlanState> _mapPlanState(UpdateSavedPlan event) async* {
    final repository = UpdateSavedPlanRepository();
    final params = state.createIngredientParameters;
    params["planDate"] = event.planDate;

    params["planPrepareIngredients"] = [
      for (int i = 0; i < event.list.length; i++)
        {
          "ingredientDbId": event.list[i].ingredientDbId,
          "ingredientName": event.list[i].ingredientName,
          "unit": event.list[i].unit,
          "quantity": event.list[i].quantity,
          "isCheck": event.list[i].isCheck,
        }
    ];

    try {
      repository.updateSavedPlan(event.id, params, (data) {
        if (data is int && (data == 200)) {
          add(const UpdateSavedPlanSuccess());
        } else {
          add(UpdateSavedPlanFailed(data as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(
          UpdatePlanStatus.Failed, ServerError.internalError());
    }
  }
}
