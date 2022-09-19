import 'package:flutter/material.dart';
import 'package:foodhub/features/home/models/recipe_app_entity.dart';

import 'package:foodhub/service/networking.dart';
import 'package:foodhub/config/endpoint.dart';

class RecipeAppRepository extends Networking {
  void getRecipeAppRepository(
    int page,
    int size,
    String sortOption,
    String search,
    String category,
    String country,
    String method,
    int time,
    int role,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(
        HTTPMethod.Get,
        Path.shared.pathGetAllRecipe,
        null,
        {
          "page": page.toString(),
          "size": size.toString(),
          "sortOption": sortOption.toString(),
          "search": search.toString(),
          "category": category.toString(),
          "country": country.toString(),
          "method": method.toString(),
          "time": time.toString(),
          "role": role.toString(),
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
