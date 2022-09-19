import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodhub/features/plan/repository/update_plan_repository.dart';
import 'package:foodhub/service/networking.dart';

part 'update_plan_event.dart';
part 'update_plan_state.dart';

class UpdatePlanBloc extends Bloc<UpdatePlanEvent, UpdatePlanState> {
  UpdatePlanBloc() : super(UpdatePlanState(status: UpdatePlanStatus.Initial));
  @override
  Stream<UpdatePlanState> mapEventToState(
    UpdatePlanEvent event,
  ) async* {
    if (event is CreateUpdatePlanEvent) {
      yield state.copyWith(UpdatePlanStatus.Processing, null);
      yield* _mapPlanState(event);
    } else if (event is UpdatePlanSuccess) {
      yield state.copyWith(UpdatePlanStatus.Success, null);
    } else if (event is UpdatePlanFailed) {
      yield state.copyWith(UpdatePlanStatus.Failed, event.error);
    }
  }

  Stream<UpdatePlanState> _mapPlanState(CreateUpdatePlanEvent event) async* {
    final repository = UpdatePlanRepository();
    final params = state.createPlanParameters;
    params["recipeId"] = event.recipeId;
    params["plannedDate"] = event.plannedDate;
    params["planCategory"] = event.planCategory;
    params["isCompleted"] = event.isCompleted;
    params["serve"] = event.serve;

    try {
      repository.updatePlan(event.planId, params, (data) {
        if (data is int && (data == 200)) {
          add(const UpdatePlanSuccess());
        } else {
          add(UpdatePlanFailed(data as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(
          UpdatePlanStatus.Failed, ServerError.internalError());
    }
  }
}
