import 'package:flutter/material.dart';
import 'package:foodhub/features/search_recipe/model/category_recipe_entity.dart';
import 'package:foodhub/service/networking.dart';
import 'package:foodhub/config/endpoint.dart';

class CategoryRecipeRepository extends Networking {
  void getCategoryRecipe(
    int page,
    int size,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(
        HTTPMethod.Get,
        Path.shared.pathGetCategoryRecipe,
        null,
        {
          "page": page.toString(),
          "size": size.toString(),
        },
        null);
    executeRequest(
      configuration,
      (response) {
        if (response.data != null) {
          final dataJson = response.data;
          final categoryResponse = CategoryRecipeResponse.fromJson(dataJson);
          completion(categoryResponse);
        } else {
          completion(response.error ?? ServerError.internalError());
        }
      },
    );
  }
}
