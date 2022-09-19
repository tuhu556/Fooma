import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodhub/features/plan/repository/delete_plan_repository.dart';
import 'package:foodhub/service/networking.dart';

part 'delete_plan_event.dart';
part 'delete_plan_state.dart';

class DeletePlanBloc extends Bloc<DeletePlanEvent, DeletePlanState> {
  DeletePlanBloc() : super(DeletePlanState(status: DeletePlanStatus.Initial));
  @override
  Stream<DeletePlanState> mapEventToState(
    DeletePlanEvent event,
  ) async* {
    if (event is CreateDeletePlanEvent) {
      yield state.copyWith(DeletePlanStatus.Processing, null);
      yield* _mapPlanState(event);
    } else if (event is DeletePlanSuccess) {
      yield state.copyWith(DeletePlanStatus.Success, null);
    } else if (event is DeletePlanFailed) {
      yield state.copyWith(DeletePlanStatus.Failed, event.error);
    }
  }

  Stream<DeletePlanState> _mapPlanState(CreateDeletePlanEvent event) async* {
    final repository = DeletePlanRepository();

    try {
      repository.deletePlan(event.id, (data) {
        if (data is int && (data == 200)) {
          add(const DeletePlanSuccess());
        } else {
          add(DeletePlanFailed(data as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(
          DeletePlanStatus.Failed, ServerError.internalError());
    }
  }
}
