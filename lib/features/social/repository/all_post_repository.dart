import 'package:flutter/material.dart';
import 'package:foodhub/features/user_profile/model/my_post_entity.dart';
import 'package:foodhub/features/user_profile/model/user_profile_entity.dart';

import '../../../service/networking.dart';
import 'package:foodhub/config/endpoint.dart';

class AllPostRestRepository extends Networking {
  void getAllPost(
    int page,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(HTTPMethod.Get,
        Path.shared.pathGetAllPost, null, {"page": page.toString()}, null);

    executeRequest(configuration, (response) {
      if (response.data != null) {
        final dataJson = response.data;
        final myPost = MyPostResponse.fromJson(dataJson);

        completion(myPost);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }
}
