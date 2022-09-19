import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodhub/features/ingredient_manager/models/ingredient_user_entity.dart';
import 'package:foodhub/features/ingredient_manager/repository/ingredient_user_repository.dart';
import 'package:foodhub/service/networking.dart';

part 'ingredient_user_event.dart';
part 'ingredient_user_state.dart';

class IngredientUserBloc
    extends Bloc<IngredientUserEvent, IngredientUserState> {
  IngredientUserBloc()
      : super(IngredientUserState(status: IngredientUserStatus.Initial));

  @override
  Stream<IngredientUserState> mapEventToState(
    IngredientUserEvent event,
  ) async* {
    if (event is IngredientUser) {
      yield state.copyWith(IngredientUserStatus.Processing, null, null, null);
      yield* _mapGetIngredientDataToState(event);
    } else if (event is GetIngredientUserSuccess) {
      yield state.copyWith(
          IngredientUserStatus.Success, event.data, null, null);
    } else if (event is GetIngredientUserFailed) {
      yield state.copyWith(
          IngredientUserStatus.Failed, null, null, event.error);
    }
  }

  Stream<IngredientUserState> _mapGetIngredientDataToState(
      IngredientUser event) async* {
    final repository = IngredientUserRepository();

    try {
      repository.getIngredientUserData(event.sortOption, event.condition,
          event.entityName, event.locationName, (value) {
        if (value is IngredientUserResponse) {
          add(GetIngredientUserSuccess(value));
        } else {
          add(GetIngredientUserFailed(value as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(
          IngredientUserStatus.Failed, null, null, ServerError.internalError());
    }
  }
}
