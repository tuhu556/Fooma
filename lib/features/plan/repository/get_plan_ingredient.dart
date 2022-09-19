import 'package:flutter/material.dart';
import 'package:foodhub/features/plan/models/plan_entity.dart';
import 'package:foodhub/service/networking.dart';

import 'package:foodhub/config/endpoint.dart';

class GetPlanIngredientRepository extends Networking {
  void getPlanIngridentData(
    String selectedDate,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(
        HTTPMethod.Get,
        Path.shared.pathGetPlanIngredient,
        null,
        {
          "date": selectedDate,
        },
        null);

    executeRequest(
      configuration,
      (response) {
        if (response.data != null) {
          final dataJson = response.data;
          final planIngredientResponse =
              PlanIngredientResponse.fromJson(dataJson);
          completion(planIngredientResponse);
        } else {
          completion(response.error ?? ServerError.internalError());
        }
      },
    );
  }
}
