import 'package:flutter/material.dart';
import 'package:foodhub/features/home/models/recipe_app_entity.dart';
import 'package:foodhub/service/networking.dart';
import 'package:foodhub/config/endpoint.dart';

class RecipeSuggestionRepository extends Networking {
  void getRecipeSuggestion(
    int page,
    int size,
    String sortOption,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(
        HTTPMethod.Get,
        Path.shared.pathGetRecipeSuggestion,
        null,
        {
          "page": page.toString(),
          "size": size.toString(),
          "sortOption": sortOption.toString(),
        },
        null);
    executeRequest(
      configuration,
      (response) {
        if (response.data != null) {
          final dataJson = response.data;
          final recipeAppData = RecipeAppResponse.fromJson(dataJson);
          completion(recipeAppData);
        } else {
          completion(response.error ?? ServerError.internalError());
        }
      },
    );
  }
}
