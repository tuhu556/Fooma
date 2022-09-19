import 'package:flutter/material.dart';
import 'package:foodhub/service/networking.dart';
import 'package:foodhub/config/endpoint.dart';

import '../models/ingredient_data_entity.dart';

class IngredientDataRepository extends Networking {
  void getIngredientData(
    int size,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(HTTPMethod.Get,
        Path.shared.pathIngredientDB, null, {"size": size.toString()}, null);

    executeRequest(
      configuration,
      (response) {
        if (response.data != null) {
          final dataJson = response.data;
          final ingredientData = IngredientResponse.fromJson(dataJson);

          completion(ingredientData);
        } else {
          completion(response.error ?? ServerError.internalError());
        }
      },
    );
  }
}
