import 'package:flutter/material.dart';
import 'package:foodhub/features/search_recipe/model/origin_recipe_repository.dart';
import 'package:foodhub/service/networking.dart';
import 'package:foodhub/config/endpoint.dart';

class OriginRecipeRepository extends Networking {
  void getOriginRecipe(
    int page,
    int size,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(
        HTTPMethod.Get,
        Path.shared.pathGetOriginRecipe,
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
          final originResponse = OriginResponse.fromJson(dataJson);
          completion(originResponse);
        } else {
          completion(response.error ?? ServerError.internalError());
        }
      },
    );
  }
}
