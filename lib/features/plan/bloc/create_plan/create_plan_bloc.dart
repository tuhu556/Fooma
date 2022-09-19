import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodhub/features/plan/repository/create_plan_repository.dart';
import 'package:foodhub/service/networking.dart';

part 'create_plan_event.dart';
part 'create_plan_state.dart';

class CreatePlanBloc extends Bloc<CreatePlanEvent, CreatePlanState> {
  CreatePlanBloc() : super(CreatePlanState(status: CreatePlanStatus.Initial));
  @override
  Stream<CreatePlanState> mapEventToState(
    CreatePlanEvent event,
  ) async* {
    if (event is CreatePlan) {
      yield state.copyWith(CreatePlanStatus.Processing, null);
      yield* _mapPlanState(event);
    } else if (event is CreatePlanSucces) {
      yield state.copyWith(CreatePlanStatus.Success, null);
    } else if (event is CreatePlanFailed) {
      yield state.copyWith(CreatePlanStatus.Failed, event.error);
    }
  }

  Stream<CreatePlanState> _mapPlanState(CreatePlan event) async* {
    final repository = CreatePlanRepository();
    final params = state.createPlanParameters;
    params["recipeId"] = event.recipeId;
    params["plannedDate"] = event.plannedDate;
    params["planCategory"] = event.planCategory;
    params["isCompleted"] = event.isCompleted;
    params["serve"] = event.serve;

    try {
      repository.createPlan(params, (data) {
        if (data is int && (data == 200)) {
          add(const CreatePlanSucces());
        } else {
          add(CreatePlanFailed(data as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(
          CreatePlanStatus.Failed, ServerError.internalError());
    }
  }
}
