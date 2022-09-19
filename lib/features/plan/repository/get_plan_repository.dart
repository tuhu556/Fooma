import 'package:flutter/material.dart';
import 'package:foodhub/features/plan/models/plan_entity.dart';
import 'package:foodhub/service/networking.dart';

import 'package:foodhub/config/endpoint.dart';

class GetPlanRepository extends Networking {
  void getPlanData(
    int page,
    int size,
    String sortOption,
    String date,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(
        HTTPMethod.Get,
        Path.shared.pathGetPlan,
        null,
        {
          "page": page.toString(),
          "size": size.toString(),
          "entityName": "PlanCategory",
          "sortOption": sortOption.toString(),
          "date": date.toString(),
        },
        null);

    executeRequest(
      configuration,
      (response) {
        if (response.data != null) {
          final dataJson = response.data;
          final planResponse = PlanResponse.fromJson(dataJson);
          completion(planResponse);
        } else {
          completion(response.error ?? ServerError.internalError());
        }
      },
    );
  }
}
