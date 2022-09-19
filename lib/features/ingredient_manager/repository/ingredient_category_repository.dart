import 'package:flutter/material.dart';
import 'package:foodhub/features/ingredient_manager/models/ingredient_category_entity.dart';
import 'package:foodhub/service/networking.dart';
import 'package:foodhub/config/endpoint.dart';

class IngredientCategoryRepository extends Networking {
  void getIngredientCategoryData(
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(HTTPMethod.Get,
        Path.shared.pathGetIngredientCategory, null, null, null);

    executeRequest(
      configuration,
      (response) {
        if (response.data != null) {
          final dataJson = response.data;
          final ingredientCategoryResponse =
              IngredientCategoryResponse.fromJson(dataJson);

          completion(ingredientCategoryResponse);
        } else {
          completion(response.error ?? ServerError.internalError());
        }
      },
    );
  }
}
