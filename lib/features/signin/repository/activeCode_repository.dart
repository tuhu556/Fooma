import 'package:flutter/material.dart';
import 'package:foodhub/features/signin/models/signin_entity.dart';

import 'package:foodhub/service/networking.dart';
import 'package:foodhub/config/endpoint.dart';

class ActiveCodeRestRepository extends Networking {
  void activeCode(
    String email,
    String code,
    ValueSetter<dynamic> completion,
  ) {
    final params = {"email": email, "code": code};
    final configuration = RequestConfiguration(
        HTTPMethod.Post, Path.shared.pathActiveCode, null, params, null);

    executeRequest(configuration, (response) {
      print(response.data);
      if (response.data != null) {
        final dataJson = response.data["token"];
        final signInResponse = AuthenticationCredential.fromJson(dataJson);
        completion(signInResponse);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }
}
