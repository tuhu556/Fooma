import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodhub/features/ingredient_manager/models/ingredient_data_entity.dart';
import 'package:foodhub/features/ingredient_manager/repository/ingredient_data_repository.dart';
import 'package:foodhub/service/networking.dart';
part 'ingredient_data_event.dart';
part 'ingredient_data_state.dart';

class IngredientDataBloc
    extends Bloc<IngredientDataEvent, IngredientDataState> {
  IngredientDataBloc()
      : super(IngredientDataState(status: IngredientDataStatus.Initial));

  @override
  Stream<IngredientDataState> mapEventToState(
    IngredientDataEvent event,
  ) async* {
    if (event is IngredientData) {
      yield state.copyWith(IngredientDataStatus.Processing, null, null, null);
      yield* _mapGetIngredientDataToState(event);
    } else if (event is GetIngredientDataSuccess) {
      yield state.copyWith(
          IngredientDataStatus.Success, event.data, null, null);
    } else if (event is GetIngredientDataFailed) {
      yield state.copyWith(
          IngredientDataStatus.Failed, null, null, event.error);
    }
  }

  Stream<IngredientDataState> _mapGetIngredientDataToState(
      IngredientData event) async* {
    final repository = IngredientDataRepository();

    try {
      repository.getIngredientData(event.size, (value) {
        if (value is IngredientResponse) {
          add(GetIngredientDataSuccess(value));
        } else {
          add(GetIngredientDataFailed(value as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(
          IngredientDataStatus.Failed, null, null, ServerError.internalError());
    }
  }
}
