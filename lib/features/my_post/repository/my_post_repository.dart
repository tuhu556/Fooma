import 'package:flutter/material.dart';
import 'package:foodhub/features/user_profile/model/user_profile_entity.dart';

import 'package:foodhub/config/endpoint.dart';

import '../../../../service/networking.dart';

class EditPostRestRepository extends Networking {
  void editMyPost(
    Map<String, dynamic> params,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(
        HTTPMethod.Put, Path.shared.pathEditMyPost, null, params, null);

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
