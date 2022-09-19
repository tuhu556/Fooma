import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/features/ingredient_manager/models/ingredient_user_entity.dart';
import 'package:foodhub/features/plan/repository/get_total_user_ingredient_repository.dart';
import 'package:foodhub/service/networking.dart';

part 'get_total_user_ingredient_event.dart';
part 'get_total_user_ingredient_state.dart';

class GetTotalUserIngredientBloc
    extends Bloc<GetTotalUserIngredientEvent, GetTotalUserIngredientState> {
  GetTotalUserIngredientBloc()
      : super(
            GetTotalUserIngredientState(status: IngredientTotalStatus.Initial));

  @override
  Stream<GetTotalUserIngredientState> mapEventToState(
    GetTotalUserIngredientEvent event,
  ) async* {
    if (event is IngredientTotal) {
      yield state.copyWith(IngredientTotalStatus.Processing, null, null, null);
      yield* _mapGetIngredientDataToState(event);
    } else if (event is GetIngredientTotalSuccess) {
      yield state.copyWith(
          IngredientTotalStatus.Success, event.data, null, null);
    } else if (event is GetIngredientTotalFailed) {
      yield state.copyWith(
          IngredientTotalStatus.Failed, null, null, event.error);
    }
  }

  Stream<GetTotalUserIngredientState> _mapGetIngredientDataToState(
      IngredientTotal event) async* {
    final repository = IngredientUserTotalRepository();

    try {
      repository.getIngredientUserTotalData((value) {
        if (value is IngredientTotalResponse) {
          add(GetIngredientTotalSuccess(value));
        } else {
          add(GetIngredientTotalFailed(value as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(IngredientTotalStatus.Failed, null, null,
          ServerError.internalError());
    }
  }
}
