import 'package:flutter/material.dart';
import 'package:foodhub/config/endpoint.dart';
import 'package:foodhub/service/networking.dart';

class DeleteIngredientRepository extends Networking {
  void deleteIngredient(
    String ingredientId,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(HTTPMethod.Delete,
        Path.shared.pathDeleteIngredient + ingredientId, null, null, null);

    executeRequest(configuration, (response) {
      if (response.data != null) {
        final code = response.data["code"];
        completion(code);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }
}
