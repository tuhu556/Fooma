import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../service/networking.dart';
import '../models/upload_recipe_entity.dart';
import '../repository/upload_recipe_repository.dart';

part 'upload_recipe_event.dart';
part 'upload_recipe_state.dart';

class UploadRecipeBloc extends Bloc<UploadRecipeEvent, UploadRecipeState> {
  UploadRecipeBloc()
      : super(UploadRecipeState(status: UploadRecipeStatus.Initial));

  @override
  Stream<UploadRecipeState> mapEventToState(
    UploadRecipeEvent event,
  ) async* {
    if (event is UploadRecipe) {
      yield state.copyWith(UploadRecipeStatus.Processing, null);
      yield* _mapUploadRecipeState(event);
    } else if (event is UploadRecipeSuccess) {
      yield state.copyWith(UploadRecipeStatus.Success, null);
    } else if (event is UploadRecipeFailed) {
      yield state.copyWith(UploadRecipeStatus.Failed, event.error);
    }
  }

  Stream<UploadRecipeState> _mapUploadRecipeState(UploadRecipe event) async* {
    final repository = UploadRecipeRestRepository();
    final params = state.uploadRecipeParameters;
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
      repository.uploadRecipe(params, (data) {
        if (data is int && (data == 200)) {
          add(const UploadRecipeSuccess());
        } else {
          add(UploadRecipeFailed(data as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(
          UploadRecipeStatus.Failed, ServerError.internalError());
    }
  }
}
