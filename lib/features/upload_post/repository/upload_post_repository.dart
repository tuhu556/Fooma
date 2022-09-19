import 'package:flutter/material.dart';
import '../../../service/networking.dart';
import 'package:foodhub/config/endpoint.dart';

class PostRestRepository extends Networking {
  void createPost(
    Map<String, dynamic> params,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(
        HTTPMethod.Post, Path.shared.pathCreatePost, null, params, null);

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
