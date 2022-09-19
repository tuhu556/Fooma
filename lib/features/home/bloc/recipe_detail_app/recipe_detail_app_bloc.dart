import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodhub/features/home/models/recipe_app_entity.dart';
import 'package:foodhub/features/home/repository/recipe_detail_app_repository.dart';
import 'package:foodhub/service/networking.dart';

part 'recipe_detail_app_event.dart';
part 'recipe_detail_app_state.dart';

class RecipeDetailAppBloc
    extends Bloc<RecipeDetailAppEvent, RecipeDetailAppState> {
  RecipeDetailAppBloc()
      : super(RecipeDetailAppState(status: RecipeDetailStatus.Initial));

  @override
  Stream<RecipeDetailAppState> mapEventToState(
    RecipeDetailAppEvent event,
  ) async* {
    if (event is RecipeDetail) {
      yield state.copyWith(RecipeDetailStatus.Processing, null, null);
      yield* _mapGetRecipeDetailState(event);
    } else if (event is GetRecipeDetailSuccess) {
      yield state.copyWith(RecipeDetailStatus.Success, event.data, null);
    } else if (event is GetRecipeDetailFailed) {
      yield state.copyWith(RecipeDetailStatus.Failed, null, event.error);
    }
  }

  Stream<RecipeDetailAppState> _mapGetRecipeDetailState(
      RecipeDetail event) async* {
    final repository = RecipeDetailAppRepository();
    String id = event.recipeId;
    print("id truyen vao: " + id);
    try {
      repository.RecipeDetail(id, (data) {
        if (data is RecipeDetailAppModel) {
          add(GetRecipeDetailSuccess(data));
        } else {
          add(GetRecipeDetailFailed(data as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(
          RecipeDetailStatus.Failed, null, ServerError.internalError());
    }
  }
}
