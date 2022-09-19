import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/features/upload_recipe/repository/edit_recipe_repository.dart';

import '../../../service/networking.dart';
import '../models/upload_recipe_entity.dart';

part 'edit_recipe_event.dart';
part 'edit_recipe_state.dart';

class EditMyRecipeBloc extends Bloc<EditMyRecipeEvent, EditMyRecipeState> {
  EditMyRecipeBloc()
      : super(EditMyRecipeState(status: EditMyRecipeStatus.Initial));

  @override
  Stream<EditMyRecipeState> mapEventToState(
    EditMyRecipeEvent event,
  ) async* {
    if (event is EditMyRecipe) {
      yield state.copyWith(EditMyRecipeStatus.Processing, null);
      yield* _mapEditMyRecipeState(event);
    } else if (event is EditMyRecipeSuccess) {
      yield state.copyWith(EditMyRecipeStatus.Success, null);
    } else if (event is EditMyRecipeFailed) {
      yield state.copyWith(EditMyRecipeStatus.Failed, event.error);
    }
  }

  Stream<EditMyRecipeState> _mapEditMyRecipeState(EditMyRecipe event) async* {
    final repository = EditRecipeRestRepository();
    final params = state.editMyRecipeParameters;
    params["originId"] = event.originId;
    params["cookingMethodId"] = event.cookingMethodId;
    params["recipeName"] = event.recipeName;
    params["description"] = event.description;
    params["preparationTime"] = event.preparationTime;
    params["cookingTime"] = event.cookingTime;
    params["serves"] = event.serves;
    params["calories"] = event.calories;
    params["hashtag"] = event.hashtag;
    params["manyToManyRecipeCategories"] = [
      for (int i = 0; i < event.manyToManyRecipeCategories!.length; i++)
        {
          "recipeCategoryId":
              event.manyToManyRecipeCategories![i].recipeCategoryId,
        }
    ];
    params["manyToManyRecipeNutritions"] = [
      for (int i = 0; i < event.manyToManyRecipeNutritions!.length; i++)
        {
          "recipeNutritionId":
              event.manyToManyRecipeNutritions![i].recipeNutritionId,
        }
    ];
    params["recipeImages"] = [
      for (int i = 0; i < event.recipeImages!.length; i++)
        {
          "orderNumber": event.recipeImages![i].orderNumber,
          "imageUrl": event.recipeImages![i].imageUrl,
          "isThumbnail": event.recipeImages![i].isThumbnail,
        }
    ];
    params["recipeIngredients"] = [
      for (int i = 0; i < event.recipeIngredients!.length; i++)
        {
          "ingredientDbid": event.recipeIngredients![i].ingredientDbid,
          "ingredientName": event.recipeIngredients![i].ingredientName,
          "unit": event.recipeIngredients![i].unit,
          "quantity": event.recipeIngredients![i].quantity,
          "isMain": event.recipeIngredients![i].isMain,
        }
    ];
    params["recipeMethods"] = [
      for (int i = 0; i < event.recipeMethods!.length; i++)
        {
          "step": event.recipeMethods![i].step,
          "content": event.recipeMethods![i].content,
          "recipeMethodImages": [
            for (int k = 0;
                k < event.recipeMethods![i].recipeMethodImages.length;
                k++)
              {
                "orderNumber":
                    event.recipeMethods![i].recipeMethodImages[k].orderNumber,
                "imageUrl":
                    event.recipeMethods![i].recipeMethodImages[k].imageUrl,
              }
          ],
        }
    ];
    print(params);

    try {
      repository.editMyRecipe(event.recipeId, params, (data) {
        if (data is int && (data == 200)) {
          add(const EditMyRecipeSuccess());
        } else {
          add(EditMyRecipeFailed(data as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(
          EditMyRecipeStatus.Failed, ServerError.internalError());
    }
  }
}
