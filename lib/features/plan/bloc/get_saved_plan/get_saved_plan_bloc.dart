import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodhub/features/plan/models/ingredientPrepare_entity.dart';
import 'package:foodhub/features/plan/repository/get_saved_plan_repository.dart';
import 'package:foodhub/service/networking.dart';

part 'get_saved_plan_event.dart';
part 'get_saved_plan_state.dart';

class GetSavedPlanBloc extends Bloc<GetSavedPlanEvent, GetSavedPlanState> {
  GetSavedPlanBloc() : super(GetSavedPlanState(status: PlanStatus.Initial));
  @override
  Stream<GetSavedPlanState> mapEventToState(
    GetSavedPlanEvent event,
  ) async* {
    if (event is GetSavedPlan) {
      yield state.copyWith(PlanStatus.Processing, null, null, null);
      yield* _mapGetPlanToState(event);
    } else if (event is GetPlanSuccess) {
      yield state.copyWith(PlanStatus.Success, event.data, null, null);
    } else if (event is GetPlanFailed) {
      yield state.copyWith(PlanStatus.Failed, null, null, event.error);
    }
  }

  Stream<GetSavedPlanState> _mapGetPlanToState(GetSavedPlan event) async* {
    final repository = GetSavedPlanRepository();

    try {
      repository.GetSavedPlan(
          event.page, event.size, event.sortOption, event.date, (value) {
        if (value is PlanPrepareResponse) {
          add(GetPlanSuccess(value));
        } else {
          add(GetPlanFailed(value as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(
          PlanStatus.Failed, null, null, ServerError.internalError());
    }
  }
}
