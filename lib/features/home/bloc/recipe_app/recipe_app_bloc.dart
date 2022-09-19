import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodhub/features/home/models/recipe_app_entity.dart';
import 'package:foodhub/features/home/repository/recipe_app_repository.dart';
import 'package:foodhub/service/networking.dart';

part 'recipe_app_event.dart';
part 'recipe_app_state.dart';

class RecipeAppBloc extends Bloc<RecipeAppEvent, RecipeAppState> {
  RecipeAppBloc() : super(RecipeAppState(status: RecipeAppStatus.Initial));
  @override
  Stream<RecipeAppState> mapEventToState(
    RecipeAppEvent event,
  ) async* {
    if (event is RecipeApp) {
      yield state.copyWith(
        RecipeAppStatus.Processing,
        null,
        null,
        null,
      );
      yield* _mapGetRecipeAppToState(event);
    } else if (event is GetRecipeAppSuccess) {
      yield state.copyWith(
        RecipeAppStatus.Success,
        event.data,
        null,
        null,
      );
    } else if (event is GetRecipeAppFailed) {
      yield state.copyWith(RecipeAppStatus.Failed, null, null, event.error);
    }
  }

  Stream<RecipeAppState> _mapGetRecipeAppToState(RecipeApp event) async* {
    final repository = RecipeAppRepository();

    try {
      repository.getRecipeAppRepository(
          event.page,
          event.size,
          event.sortOption,
          event.search,
          event.category,
          event.country,
          event.method,
          event.time,
          event.role, (value) {
        if (value is RecipeAppResponse) {
          add(GetRecipeAppSuccess(value));
        } else {
          add(GetRecipeAppFailed(value as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(
          RecipeAppStatus.Failed, null, null, ServerError.internalError());
    }
  }
}
