import 'package:flutter/material.dart';
import 'package:foodhub/features/ingredient_manager/models/ingredient_user_entity.dart';
import 'package:foodhub/service/networking.dart';
import 'package:foodhub/config/endpoint.dart';

class IngredientUserRepository extends Networking {
  void getIngredientUserData(
    String sortOption,
    String condition,
    String entityName,
    String locationName,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(
        HTTPMethod.Get,
        Path.shared.pathIngredientUser,
        null,
        {
          "sortOption": sortOption.toString(),
          "condition": condition.toString(),
          "entityName": entityName.toString(),
          "locationName": locationName.toString(),
        },
        null);

    executeRequest(
      configuration,
      (response) {
        if (response.data != null) {
          final dataJson = response.data;
          final ingredientUserData = IngredientUserResponse.fromJson(dataJson);

          completion(ingredientUserData);
        } else {
          completion(response.error ?? ServerError.internalError());
        }
      },
    );
  }
}
