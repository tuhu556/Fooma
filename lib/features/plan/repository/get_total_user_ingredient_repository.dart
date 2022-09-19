import 'package:flutter/material.dart';
import 'package:foodhub/features/ingredient_manager/models/ingredient_user_entity.dart';
import 'package:foodhub/service/networking.dart';
import 'package:foodhub/config/endpoint.dart';

class IngredientUserTotalRepository extends Networking {
  void getIngredientUserTotalData(
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(
        HTTPMethod.Get, Path.shared.pathIngredientTotalUser, null, null, null);

    executeRequest(
      configuration,
      (response) {
        if (response.data != null) {
          final dataJson = response.data;
          final ingredientUserData = IngredientTotalResponse.fromJson(dataJson);

          completion(ingredientUserData);
        } else {
          completion(response.error ?? ServerError.internalError());
        }
      },
    );
  }
}
