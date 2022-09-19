import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodhub/features/search_recipe/model/origin_recipe_repository.dart';
import 'package:foodhub/features/search_recipe/repository/origin_recipe_repository.dart';
import 'package:foodhub/service/networking.dart';

part 'origin_recipe_event.dart';
part 'origin_recipe_state.dart';

class OriginRecipeBloc extends Bloc<OriginRecipeEvent, OriginRecipeState> {
  OriginRecipeBloc() : super(OriginRecipeState(status: OriginStatus.Initial));
  @override
  Stream<OriginRecipeState> mapEventToState(
    OriginRecipeEvent event,
  ) async* {
    if (event is OriginRecipe) {
      yield state.copyWith(OriginStatus.Processing, null, null, null);
      yield* _mapOriginRecipeToState(event);
    } else if (event is GetOriginSuccess) {
      yield state.copyWith(OriginStatus.Success, event.data, null, null);
    } else if (event is GetOriginFailed) {
      yield state.copyWith(OriginStatus.Failed, null, null, event.error);
    }
  }

  Stream<OriginRecipeState> _mapOriginRecipeToState(OriginRecipe event) async* {
    final repository = OriginRecipeRepository();

    try {
      repository.getOriginRecipe(event.page, event.size, (value) {
        if (value is OriginResponse) {
          add(GetOriginSuccess(value));
        } else {
          add(GetOriginFailed(value as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(
          OriginStatus.Failed, null, null, ServerError.internalError());
    }
  }
}
