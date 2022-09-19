import 'package:flutter/material.dart';
import 'package:foodhub/features/search_recipe/model/method_recipe_entity.dart';
import 'package:foodhub/service/networking.dart';
import 'package:foodhub/config/endpoint.dart';

class MethodRecipeRepository extends Networking {
  void getMethodRecipe(
    int page,
    int size,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(
        HTTPMethod.Get,
        Path.shared.pathGetMethodRecipe,
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
          final methodResponse = MethodRecipeResponse.fromJson(dataJson);
          completion(methodResponse);
        } else {
          completion(response.error ?? ServerError.internalError());
        }
      },
    );
  }
}
