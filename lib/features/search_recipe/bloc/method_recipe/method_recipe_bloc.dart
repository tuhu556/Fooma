import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodhub/features/search_recipe/model/method_recipe_entity.dart';
import 'package:foodhub/features/search_recipe/repository/method_recipe_repository.dart';
import 'package:foodhub/service/networking.dart';

part 'method_recipe_event.dart';
part 'method_recipe_state.dart';

class MethodRecipeBloc extends Bloc<MethodRecipeEvent, MethodRecipeState> {
  MethodRecipeBloc() : super(MethodRecipeState(status: MethodStatus.Initial));
  @override
  Stream<MethodRecipeState> mapEventToState(
    MethodRecipeEvent event,
  ) async* {
    if (event is MethodRecipe) {
      yield state.copyWith(MethodStatus.Processing, null, null, null);
      yield* _mapCategoryRecipeToState(event);
    } else if (event is GetMethodSuccess) {
      yield state.copyWith(MethodStatus.Success, event.data, null, null);
    } else if (event is GetMethodFailed) {
      yield state.copyWith(MethodStatus.Failed, null, null, event.error);
    }
  }

  Stream<MethodRecipeState> _mapCategoryRecipeToState(
      MethodRecipe event) async* {
    final repository = MethodRecipeRepository();

    try {
      repository.getMethodRecipe(event.page, event.size, (value) {
        if (value is MethodRecipeResponse) {
          add(GetMethodSuccess(value));
        } else {
          add(GetMethodFailed(value as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(
          MethodStatus.Failed, null, null, ServerError.internalError());
    }
  }
}
