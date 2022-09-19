import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodhub/features/home/models/recipe_app_entity.dart';
import 'package:foodhub/features/saved_recipe/repository/saved_recipe_repository.dart';
import 'package:foodhub/service/networking.dart';

part 'saved_recipe_event.dart';
part 'saved_recipe_state.dart';

class SavedRecipeBloc extends Bloc<SavedRecipeEvent, SavedRecipeState> {
  SavedRecipeBloc()
      : super(SavedRecipeState(status: SavedRecipeStatus.Initial));
  @override
  Stream<SavedRecipeState> mapEventToState(
    SavedRecipeEvent event,
  ) async* {
    if (event is GetSavedRecipe) {
      yield state.copyWith(
        SavedRecipeStatus.Processing,
        null,
        null,
        null,
      );
      yield* _mapGetRecipeAppToState(event);
    } else if (event is GetSavedRecipeSuccess) {
      yield state.copyWith(
        SavedRecipeStatus.Success,
        event.data,
        null,
        null,
      );
    } else if (event is GetSavedRecipeFailed) {
      yield state.copyWith(SavedRecipeStatus.Failed, null, null, event.error);
    }
  }

  Stream<SavedRecipeState> _mapGetRecipeAppToState(
      GetSavedRecipe event) async* {
    final repository = SavedRecipeRepository();

    try {
      repository.getSavedRecipe(
          event.page, event.size, event.sortOption, event.role, (value) {
        if (value is RecipeAppResponse) {
          add(GetSavedRecipeSuccess(value));
        } else {
          add(GetSavedRecipeFailed(value as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(
          SavedRecipeStatus.Failed, null, null, ServerError.internalError());
    }
  }
}
