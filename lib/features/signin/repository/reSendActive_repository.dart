import 'package:flutter/material.dart';

import 'package:foodhub/service/networking.dart';
import 'package:foodhub/config/endpoint.dart';

class ReSendActiveRepository extends Networking {
  void reSendActive(
    String email,
    ValueSetter<dynamic> completion,
  ) {
    final params = {"email": email};
    final configuration = RequestConfiguration(
        HTTPMethod.Post, Path.shared.pathReSendActive, null, params, null);

    executeRequest(configuration, (response) {
      print(response.data);
      if (response.data != null) {
        final dataJson = response.data["code"];
        completion(dataJson);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }
}
