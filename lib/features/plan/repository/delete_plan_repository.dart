import 'package:flutter/material.dart';
import 'package:foodhub/service/networking.dart';
import 'package:foodhub/config/endpoint.dart';

class DeletePlanRepository extends Networking {
  void deletePlan(
    String id,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(
        HTTPMethod.Delete, Path.shared.pathDeletePlan + id, null, null, null);

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
