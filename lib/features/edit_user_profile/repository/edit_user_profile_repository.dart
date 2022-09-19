import 'package:flutter/material.dart';

import '../../../service/networking.dart';
import 'package:foodhub/config/endpoint.dart';

class EditUserProfileRestRepository extends Networking {
  void editUserProfile(
    Map<String, dynamic> params,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(
        HTTPMethod.Put, Path.shared.pathEditUserProfile, null, params, null);

    executeRequest(configuration, (response) {
      if (response.data != null) {
        final token = response.data["code"];
        completion(token);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }
}
