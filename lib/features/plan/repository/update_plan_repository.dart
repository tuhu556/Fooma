import 'package:flutter/material.dart';
import 'package:foodhub/service/networking.dart';
import 'package:foodhub/config/endpoint.dart';

class UpdatePlanRepository extends Networking {
  void updatePlan(
    String id,
    Map<String, dynamic> params,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(
        HTTPMethod.Put, Path.shared.pathUpdatePlan + id, null, params, null);
    executeRequest(configuration, (response) {
      if (response.data != null) {
        final statusCode = response.data["code"];
        completion(statusCode);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }
}
