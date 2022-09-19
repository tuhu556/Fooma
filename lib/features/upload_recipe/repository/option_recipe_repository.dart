import 'package:flutter/material.dart';
import 'package:foodhub/features/upload_recipe/models/ingredient_entity.dart';
import 'package:foodhub/features/upload_recipe/models/recipe_meal_entity.dart';
import 'package:foodhub/features/upload_recipe/models/recipe_origin_entity.dart';
import 'package:foodhub/features/upload_recipe/models/recipe_process_entity.dart';

import '../../../service/networking.dart';
import 'package:foodhub/config/endpoint.dart';

class OptionRecipeRestRepository extends Networking {
  void getRecipeOrigin(
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(HTTPMethod.Get,
        Path.shared.pathRecipeOrigin, null, {"size": "100"}, null);

    executeRequest(configuration, (response) {
      if (response.data != null) {
        final dataJson = response.data;
        final recipeOrigin = RecipeOriginResponse.fromJson(dataJson);
        completion(recipeOrigin);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }

  void getRecipeMeal(
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(HTTPMethod.Get,
        Path.shared.pathRecipeMeal, null, {"size": "100"}, null);

    executeRequest(configuration, (response) {
      if (response.data != null) {
        final dataJson = response.data;
        final recipeMeal = RecipeMealResponse.fromJson(dataJson);
        completion(recipeMeal);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }

  void getRecipeProcess(
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(HTTPMethod.Get,
        Path.shared.pathRecipeProcess, null, {"size": "100"}, null);

    executeRequest(configuration, (response) {
      if (response.data != null) {
        final dataJson = response.data;
        final recipeProcess = RecipeProcessResponse.fromJson(dataJson);
        completion(recipeProcess);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }

  void getIngredientDB(
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(HTTPMethod.Get,
        Path.shared.pathIngredientDB, null, {"size": "1000"}, null);

    executeRequest(configuration, (response) {
      if (response.data != null) {
        final dataJson = response.data;
        final listIngredient = IngredientResponse.fromJson(dataJson);
        completion(listIngredient);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }
}
