import 'package:flutter/material.dart';

import 'package:foodhub/config/endpoint.dart';

import '../../../../service/networking.dart';

class EditRecipeRestRepository extends Networking {
  void editMyRecipe(
    String id,
    Map<String, dynamic> params,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(HTTPMethod.Put,
        Path.shared.pathDeleteMyRecipe + "/" + id, null, params, null);

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
