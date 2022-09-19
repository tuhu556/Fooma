import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';

import 'package:flutter/material.dart';

import '../../../service/networking.dart';
import '../models/favorite_recipe_entity.dart';
import '../repository/favorite_post_repository.dart';
part 'favorite_recipe_event.dart';

part 'favorite_recipe_state.dart';

class MyFavoriteRecipeBloc
    extends Bloc<MyFavoriteRecipeEvent, MyFavoriteRecipeState> {
  MyFavoriteRecipeBloc()
      : super(MyFavoriteRecipeState(status: MyFavoriteRecipeStatus.Initial));

  @override
  Stream<MyFavoriteRecipeState> mapEventToState(
    MyFavoriteRecipeEvent event,
  ) async* {
    if (event is MyFavoriteRecipe) {
      yield state.copyWith(MyFavoriteRecipeStatus.Processing, null, null, null);
      yield* _mapGetMyFavoriteRecipeToState(event);
    } else if (event is GetMyFavoriteRecipeDetailSuccess) {
      yield state.copyWith(
          MyFavoriteRecipeStatus.Success, event.data, null, null);
    } else if (event is GetMyFavoriteRecipeDetailFailed) {
      yield state.copyWith(
          MyFavoriteRecipeStatus.Failed, null, null, event.error);
    } else if (event is SaveRecipe) {
      yield state.copyWith(
          MyFavoriteRecipeStatus.SaveProcessing, null, null, null);
      yield* _mapSaveRecipeToState(event);
    } else if (event is SaveRecipeSuccess) {
      yield state.copyWith(
          MyFavoriteRecipeStatus.SaveSuccess, null, null, null);
    } else if (event is SaveRecipeFailed) {
      yield state.copyWith(
          MyFavoriteRecipeStatus.SaveFailed, null, null, event.error);
    } else if (event is UnSaveRecipe) {
      yield state.copyWith(
          MyFavoriteRecipeStatus.UnSaveProcessing, null, null, null);
      yield* _mapUnSaveRecipeToState(event);
    } else if (event is UnSaveRecipeSuccess) {
      yield state.copyWith(
          MyFavoriteRecipeStatus.UnSaveSuccess, null, null, null);
    } else if (event is UnSaveRecipeFailed) {
      yield state.copyWith(
          MyFavoriteRecipeStatus.UnSaveFailed, null, null, event.error);
    } else if (event is GetRecipeDetail) {
      yield state.copyWith(
          MyFavoriteRecipeStatus.RecipeDetailProcessing, null, null, null);
      yield* _mapGetRecipeDetailToState(event);
    } else if (event is GetRecipeDetailSuccess) {
      yield state.copyWith(
          MyFavoriteRecipeStatus.RecipeDetailSuccess, null, event.data, null);
    } else if (event is GetRecipeDetailFailed) {
      yield state.copyWith(
          MyFavoriteRecipeStatus.RecipeDetailFailed, null, null, event.error);
    }
  }

  Stream<MyFavoriteRecipeState> _mapGetMyFavoriteRecipeToState(
      MyFavoriteRecipe event) async* {
    final repository = MyFavoriteRecipeRestRepository();

    try {
      repository.getMyFavoriteRecipe((value) {
        if (value is MyFavoriteRecipeResponse) {
          add(GetMyFavoriteRecipeDetailSuccess(value));
        } else {
          add(GetMyFavoriteRecipeDetailFailed(value as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(MyFavoriteRecipeStatus.Failed, null, null,
          ServerError.internalError());
    }
  }

  Stream<MyFavoriteRecipeState> _mapGetRecipeDetailToState(
      GetRecipeDetail event) async* {
    final repository = MyFavoriteRecipeRestRepository();

    try {
      repository.getRecipeById(event.recipeId, (value) {
        if (value is Recipe) {
          add(GetRecipeDetailSuccess(value));
        } else {
          add(GetRecipeDetailFailed(value as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(MyFavoriteRecipeStatus.RecipeDetailFailed, null,
          null, ServerError.internalError());
    }
  }

  Stream<MyFavoriteRecipeState> _mapSaveRecipeToState(SaveRecipe event) async* {
    final repository = MyFavoriteRecipeRestRepository();

    try {
      repository.saveRecipe(event.recipeId, (data) {
        if (data is int && (data == 200) || data == 204) {
          add(const SaveRecipeSuccess());
        } else {
          add(SaveRecipeFailed(data as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(MyFavoriteRecipeStatus.SaveFailed, null, null,
          ServerError.internalError());
    }
  }

  Stream<MyFavoriteRecipeState> _mapUnSaveRecipeToState(
      UnSaveRecipe event) async* {
    final repository = MyFavoriteRecipeRestRepository();

    try {
      repository.unSaveRecipe(event.recipeId, (data) {
        if (data is int && (data == 200) || data == 204) {
          add(const UnSaveRecipeSuccess());
        } else {
          add(UnSaveRecipeFailed(data as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(MyFavoriteRecipeStatus.UnSaveFailed, null, null,
          ServerError.internalError());
    }
  }
}
