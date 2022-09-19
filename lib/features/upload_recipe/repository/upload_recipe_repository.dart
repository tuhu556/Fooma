import 'package:flutter/material.dart';

import '../../../service/networking.dart';
import 'package:foodhub/config/endpoint.dart';

class UploadRecipeRestRepository extends Networking {
  void uploadRecipe(
    Map<String, dynamic> params,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(
        HTTPMethod.Post, Path.shared.pathRecipe, null, params, null);

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
