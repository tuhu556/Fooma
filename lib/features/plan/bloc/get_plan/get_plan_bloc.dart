import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodhub/features/plan/models/plan_entity.dart';
import 'package:foodhub/features/plan/repository/get_plan_repository.dart';
import 'package:foodhub/service/networking.dart';

part 'get_plan_event.dart';
part 'get_plan_state.dart';

class GetPlanBloc extends Bloc<GetPlanEvent, GetPlanState> {
  GetPlanBloc() : super(GetPlanState(status: PlanStatus.Initial));
  @override
  Stream<GetPlanState> mapEventToState(
    GetPlanEvent event,
  ) async* {
    if (event is Plan) {
      yield state.copyWith(PlanStatus.Processing, null, null, null);
      yield* _mapGetPlanToState(event);
    } else if (event is GetPlanSuccess) {
      yield state.copyWith(PlanStatus.Success, event.data, null, null);
    } else if (event is GetPlanFailed) {
      yield state.copyWith(PlanStatus.Failed, null, null, event.error);
    }
  }

  Stream<GetPlanState> _mapGetPlanToState(Plan event) async* {
    final repository = GetPlanRepository();

    try {
      repository.getPlanData(
          event.page, event.size, event.sortOption, event.date, (value) {
        if (value is PlanResponse) {
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
