import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';

import 'package:flutter/material.dart';
import 'package:foodhub/features/social/repository/all_Recipe_repository.dart';

import '../../../service/networking.dart';
import '../models/recipe_entity.dart';
part 'all_recipe_event.dart';

part 'all_recipe_state.dart';

class AllRecipeBloc extends Bloc<AllRecipeEvent, AllRecipeState> {
  AllRecipeBloc() : super(AllRecipeState(status: AllRecipeStatus.Initial));

  @override
  Stream<AllRecipeState> mapEventToState(
    AllRecipeEvent event,
  ) async* {
    if (event is AllRecipe) {
      yield state.copyWith(AllRecipeStatus.Processing, null, null);
      yield* _mapGetListRecipeToState(event);
    } else if (event is GetAllRecipeSuccess) {
      yield state.copyWith(AllRecipeStatus.Success, event.listRecipe, null);
    } else if (event is GetAllRecipeFailed) {
      yield state.copyWith(AllRecipeStatus.Failed, null, event.error);
    }
  }

  Stream<AllRecipeState> _mapGetListRecipeToState(AllRecipe event) async* {
    final repository = AllRecipeRestRepository();

    try {
      repository.getAllRecipe(event.page, (value) {
        if (value is RecipeResponse) {
          add(GetAllRecipeSuccess(value));
        } else {
          add(GetAllRecipeFailed(value as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(
          AllRecipeStatus.Failed, null, ServerError.internalError());
    }
  }
}
