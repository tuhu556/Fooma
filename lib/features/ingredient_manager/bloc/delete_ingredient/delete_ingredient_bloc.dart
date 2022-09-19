import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/features/ingredient_manager/repository/delete_ingredient_repository.dart';
import 'package:foodhub/service/networking.dart';

part 'delete_ingredient_event.dart';
part 'delete_ingredient_state.dart';

class DeleteIngredientBloc
    extends Bloc<DeleteIngredientEvent, DeleteIngredientState> {
  DeleteIngredientBloc()
      : super(DeleteIngredientState(status: DeleteIngredientStatus.Initial));
  @override
  Stream<DeleteIngredientState> mapEventToState(
    DeleteIngredientEvent event,
  ) async* {
    if (event is CreateDeleteIngredientEvent) {
      yield state.copyWith(DeleteIngredientStatus.Processing, null);
      yield* _mapIngredientState(event);
    } else if (event is DeleteIngredientSuccess) {
      yield state.copyWith(DeleteIngredientStatus.Success, null);
    } else if (event is DeleteIngredientFailed) {
      yield state.copyWith(DeleteIngredientStatus.Failed, event.error);
    }
  }

  Stream<DeleteIngredientState> _mapIngredientState(
      CreateDeleteIngredientEvent event) async* {
    final repository = DeleteIngredientRepository();

    try {
      repository.deleteIngredient(event.id, (data) {
        if (data is int && (data == 200)) {
          add(const DeleteIngredientSuccess());
        } else {
          add(DeleteIngredientFailed(data as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(
          DeleteIngredientStatus.Failed, ServerError.internalError());
    }
  }
}
