import 'package:flutter/material.dart';
import 'package:foodhub/service/networking.dart';
import 'package:foodhub/config/endpoint.dart';

class VerifyEmailRestRepository extends Networking {
  void verifyEmail(
    Map<String, dynamic> params,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(
        HTTPMethod.Post, Path.shared.pathVerifyEmail, null, params, null);

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
