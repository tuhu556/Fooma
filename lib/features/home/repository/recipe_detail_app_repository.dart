import 'package:flutter/material.dart';
import 'package:foodhub/features/home/models/recipe_app_entity.dart';
import 'package:foodhub/service/networking.dart';
import 'package:foodhub/config/endpoint.dart';

class RecipeDetailAppRepository extends Networking {
  void RecipeDetail(
    String recipeId,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(HTTPMethod.Get,
        Path.shared.pathGetRecipeDetailApp + recipeId, null, null, null);
    executeRequest(configuration, (response) {
      print(response.data);
      if (response.data != null) {
        final dataJson = response.data;
        final recipeDetailAppData = RecipeDetailAppModel.fromJson(dataJson);
        completion(recipeDetailAppData);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }
}
