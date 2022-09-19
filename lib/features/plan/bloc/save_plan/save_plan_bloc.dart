import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodhub/features/plan/models/ingredientPrepare_entity.dart';
import 'package:foodhub/features/plan/repository/save_plan_repository.dart';
import 'package:foodhub/service/networking.dart';

part 'save_plan_event.dart';
part 'save_plan_state.dart';

class SavePlanBloc extends Bloc<SavePlanEvent, SavePlanState> {
  SavePlanBloc() : super(SavePlanState(status: SavePlanStatus.Initial));
  @override
  Stream<SavePlanState> mapEventToState(
    SavePlanEvent event,
  ) async* {
    if (event is SavePlan) {
      yield state.copyWith(SavePlanStatus.Processing, null);
      yield* _mapPlanState(event);
    } else if (event is SavePlanSuccess) {
      yield state.copyWith(SavePlanStatus.Success, null);
    } else if (event is SavePlanFailed) {
      yield state.copyWith(SavePlanStatus.Failed, event.error);
    }
  }

  Stream<SavePlanState> _mapPlanState(SavePlan event) async* {
    final repository = SavePlanRepository();
    final params = state.createPostParameters;
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
      repository.createSavePlan(params, (data) {
        if (data is int && (data == 200)) {
          add(const SavePlanSuccess());
        } else {
          add(SavePlanFailed(data as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(SavePlanStatus.Failed, ServerError.internalError());
    }
  }
}
