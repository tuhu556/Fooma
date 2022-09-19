import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/features/home/repository/unsave_recipe_repository.dart';
import 'package:foodhub/service/networking.dart';

part 'unsave_recipe_event.dart';
part 'unsave_recipe_state.dart';

class UnsaveRecipeBloc extends Bloc<UnsaveRecipeEvent, UnsaveRecipeState> {
  UnsaveRecipeBloc()
      : super(UnsaveRecipeState(status: UnSaveRecipeStatus.Initial));

  @override
  Stream<UnsaveRecipeState> mapEventToState(
    UnsaveRecipeEvent event,
  ) async* {
    if (event is UnSaveRecipe) {
      yield state.copyWith(UnSaveRecipeStatus.Processing, null);
      yield* _mapUnSaveRecipeState(event);
    } else if (event is UnSaveRecipeSuccess) {
      yield state.copyWith(UnSaveRecipeStatus.Success, null);
    } else if (event is UnSaveRecipeFailed) {
      yield state.copyWith(UnSaveRecipeStatus.Failed, event.error);
    }
  }

  Stream<UnsaveRecipeState> _mapUnSaveRecipeState(UnSaveRecipe event) async* {
    final repository = UnSaveRecipeRepository();
    final params = state.createParameters;
    params["recipeId"] = event.id;

    try {
      repository.unSaveRecipe(params, (data) {
        if (data is int && (data == 200)) {
          add(const UnSaveRecipeSuccess());
        } else {
          add(UnSaveRecipeFailed(data as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(
          UnSaveRecipeStatus.Failed, ServerError.internalError());
    }
  }
}
