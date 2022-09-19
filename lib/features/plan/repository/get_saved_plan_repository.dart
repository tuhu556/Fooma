import 'package:foodhub/features/plan/models/ingredientPrepare_entity.dart';
import 'package:foodhub/service/networking.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/config/endpoint.dart';

class GetSavedPlanRepository extends Networking {
  void GetSavedPlan(
    int page,
    int size,
    String sortOption,
    String date,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(
        HTTPMethod.Get,
        Path.shared.pathGetSavedPlan,
        null,
        {
          "page": page.toString(),
          "size": size.toString(),
          "entityName": "PlanDate",
          "sortOption": sortOption.toString(),
          "date": date.toString(),
        },
        null);

    executeRequest(
      configuration,
      (response) {
        if (response.data != null) {
          final dataJson = response.data;
          final planPrepareResponse = PlanPrepareResponse.fromJson(dataJson);
          completion(planPrepareResponse);
        } else {
          completion(response.error ?? ServerError.internalError());
        }
      },
    );
  }
}
