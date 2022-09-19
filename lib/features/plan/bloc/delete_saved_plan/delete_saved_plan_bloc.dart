import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodhub/features/plan/repository/delete_saved_plan_repository.dart';
import 'package:foodhub/service/networking.dart';

part 'delete_saved_plan_event.dart';
part 'delete_saved_plan_state.dart';

class DeleteSavedPlanBloc
    extends Bloc<DeleteSavedPlanEvent, DeleteSavedPlanState> {
  DeleteSavedPlanBloc()
      : super(DeleteSavedPlanState(status: DeletePlanStatus.Initial));
  @override
  Stream<DeleteSavedPlanState> mapEventToState(
    DeleteSavedPlanEvent event,
  ) async* {
    if (event is DeletePlan) {
      yield state.copyWith(DeletePlanStatus.Processing, null);
      yield* _mapPlanState(event);
    } else if (event is DeletePlanSuccess) {
      yield state.copyWith(DeletePlanStatus.Success, null);
    } else if (event is DeletePlanFailed) {
      yield state.copyWith(DeletePlanStatus.Failed, event.error);
    }
  }

  Stream<DeleteSavedPlanState> _mapPlanState(DeletePlan event) async* {
    final repository = DeleteSavedPlanRepository();

    try {
      repository.deleteIngredient(event.id, (data) {
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
