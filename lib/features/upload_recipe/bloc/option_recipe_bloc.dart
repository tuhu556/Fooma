import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';

import 'package:flutter/material.dart';
import 'package:foodhub/features/upload_recipe/models/recipe_meal_entity.dart';
import 'package:foodhub/features/upload_recipe/models/recipe_origin_entity.dart';
import 'package:foodhub/features/upload_recipe/models/recipe_process_entity.dart';

import '../../../service/networking.dart';
import '../models/ingredient_entity.dart';
import '../repository/option_recipe_repository.dart';
part 'option_recipe_event.dart';

part 'option_recipe_state.dart';

class OptionRecipeBloc extends Bloc<OptionRecipeEvent, OptionRecipeState> {
  OptionRecipeBloc()
      : super(OptionRecipeState(status: OptionRecipeStatus.Initial));

  @override
  Stream<OptionRecipeState> mapEventToState(
    OptionRecipeEvent event,
  ) async* {
    if (event is RecipeOrigins) {
      yield state.copyWith(
          OptionRecipeStatus.Processing, null, null, null, null, null);
      yield* _mapGetRecipeOriginToState(event);
    } else if (event is GetRecipeOriginSuccess) {
      yield state.copyWith(OptionRecipeStatus.Success, event.recipeOrigin, null,
          null, null, null);
    } else if (event is GetRecipeOriginFailed) {
      yield state.copyWith(
          OptionRecipeStatus.Failed, null, null, null, null, event.error);
    } else if (event is RecipeMeals) {
      yield state.copyWith(
          OptionRecipeStatus.MealProcessing, null, null, null, null, null);
      yield* _mapGetRecipeMealToState(event);
    } else if (event is GetRecipeMealSuccess) {
      yield state.copyWith(OptionRecipeStatus.MealSuccess, null,
          event.recipeMeal, null, null, null);
    } else if (event is GetRecipeMealFailed) {
      yield state.copyWith(
          OptionRecipeStatus.MealFailed, null, null, null, null, event.error);
    } else if (event is RecipeProcesss) {
      yield state.copyWith(
          OptionRecipeStatus.ProcessProcessing, null, null, null, null, null);
      yield* _mapGetRecipeProcessToState(event);
    } else if (event is GetRecipeProcessSuccess) {
      yield state.copyWith(OptionRecipeStatus.ProcessSuccess, null, null,
          event.recipeProcess, null, null);
    } else if (event is GetRecipeProcessFailed) {
      yield state.copyWith(OptionRecipeStatus.ProcessFailed, null, null, null,
          null, event.error);
    } else if (event is IngredientDB) {
      yield state.copyWith(OptionRecipeStatus.IngredientProcessing, null, null,
          null, null, null);
      yield* _mapGetIngredientDBToState(event);
    } else if (event is GetIngredientDBSuccess) {
      yield state.copyWith(OptionRecipeStatus.IngredientSuccess, null, null,
          null, event.ingredientResponse, null);
    } else if (event is GetIngredientDBFailed) {
      yield state.copyWith(OptionRecipeStatus.IngredientFailed, null, null,
          null, null, event.error);
    }
  }

  Stream<OptionRecipeState> _mapGetRecipeOriginToState(
      RecipeOrigins event) async* {
    final repository = OptionRecipeRestRepository();

    try {
      repository.getRecipeOrigin((value) {
        if (value is RecipeOriginResponse) {
          add(GetRecipeOriginSuccess(value));
        } else {
          add(GetRecipeOriginFailed(value as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(OptionRecipeStatus.Failed, null, null, null, null,
          ServerError.internalError());
    }
  }

  Stream<OptionRecipeState> _mapGetRecipeMealToState(RecipeMeals event) async* {
    final repository = OptionRecipeRestRepository();

    try {
      repository.getRecipeMeal((value) {
        if (value is RecipeMealResponse) {
          add(GetRecipeMealSuccess(value));
        } else {
          add(GetRecipeMealFailed(value as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(OptionRecipeStatus.MealFailed, null, null, null,
          null, ServerError.internalError());
    }
  }

  Stream<OptionRecipeState> _mapGetRecipeProcessToState(
      RecipeProcesss event) async* {
    final repository = OptionRecipeRestRepository();

    try {
      repository.getRecipeProcess((value) {
        if (value is RecipeProcessResponse) {
          add(GetRecipeProcessSuccess(value));
        } else {
          add(GetRecipeProcessFailed(value as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(OptionRecipeStatus.ProcessFailed, null, null, null,
          null, ServerError.internalError());
    }
  }

  Stream<OptionRecipeState> _mapGetIngredientDBToState(
      IngredientDB event) async* {
    final repository = OptionRecipeRestRepository();

    try {
      repository.getIngredientDB((value) {
        if (value is IngredientResponse) {
          add(GetIngredientDBSuccess(value));
        } else {
          add(GetIngredientDBFailed(value as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(OptionRecipeStatus.IngredientFailed, null, null,
          null, null, ServerError.internalError());
    }
  }
}
