import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodhub/features/home/repository/save_recipe_repository.dart';
import 'package:foodhub/service/networking.dart';

part 'save_recipe_event.dart';
part 'save_recipe_state.dart';

class SaveRecipeBloc extends Bloc<SaveRecipeEvent, SaveRecipeState> {
  SaveRecipeBloc() : super(SaveRecipeState(status: SaveRecipeStatus.Initial));

  @override
  Stream<SaveRecipeState> mapEventToState(
    SaveRecipeEvent event,
  ) async* {
    if (event is SaveRecipe) {
      yield state.copyWith(SaveRecipeStatus.Processing, null);
      yield* _mapSaveRecipeState(event);
    } else if (event is SaveRecipeSuccess) {
      yield state.copyWith(SaveRecipeStatus.Success, null);
    } else if (event is SaveRecipeFailed) {
      yield state.copyWith(SaveRecipeStatus.Failed, event.error);
    }
  }

  Stream<SaveRecipeState> _mapSaveRecipeState(SaveRecipe event) async* {
    final repository = SaveRecipeRepository();
    final params = state.createParameters;
    params["recipeId"] = event.id;

    print(params);

    try {
      repository.saveRecipe(params, (data) {
        if (data is int && (data == 200)) {
          add(const SaveRecipeSuccess());
        } else {
          add(SaveRecipeFailed(data as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(
          SaveRecipeStatus.Failed, ServerError.internalError());
    }
  }
}
