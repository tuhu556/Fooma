import 'package:flutter/material.dart';
import 'package:foodhub/features/social/models/recipe_entity.dart';

import '../../../service/networking.dart';
import 'package:foodhub/config/endpoint.dart';

class AllRecipeRestRepository extends Networking {
  void getAllRecipe(
    int page,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(HTTPMethod.Get,
        Path.shared.pathRecipe, null, {"page": page.toString()}, null);

    executeRequest(configuration, (response) {
      if (response.data != null) {
        final dataJson = response.data;
        final listRecipe = RecipeResponse.fromJson(dataJson);

        completion(listRecipe);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }
}
