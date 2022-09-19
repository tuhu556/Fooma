import 'package:flutter/material.dart';
import 'package:foodhub/features/social/models/recipe_entity.dart';

import '../../../service/networking.dart';
import 'package:foodhub/config/endpoint.dart';

import '../../user_profile/model/my_post_entity.dart';
import '../../user_profile/model/user_profile_entity.dart';

class OthersUserProfileRestRepository extends Networking {
  void getOthersUserProfile(
    final String userId,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(HTTPMethod.Get,
        Path.shared.pathGetOthersUserProfile + '/' + userId, null, null, null);

    executeRequest(configuration, (response) {
      if (response.data != null) {
        final dataJson = response.data;
        final othersUserProfile = UserProfileResponse.fromJson(dataJson);

        completion(othersUserProfile);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }

  void getOthersPost(
    int page,
    int status,
    String userId,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(
        HTTPMethod.Get,
        Path.shared.pathGetOthersPost,
        null,
        {
          "userId": userId,
          "status": status.toString(),
          "page": page.toString()
        },
        null);

    executeRequest(configuration, (response) {
      if (response.data != null) {
        final dataJson = response.data;
        final othersPost = MyPostResponse.fromJson(dataJson);

        completion(othersPost);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }

  void getOthersRecipe(
    int page,
    int status,
    String userId,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(
        HTTPMethod.Get,
        Path.shared.pathGetOthersRecipe,
        null,
        {
          "userId": userId,
          "status": status.toString(),
          "page": page.toString()
        },
        null);

    executeRequest(configuration, (response) {
      if (response.data != null) {
        final dataJson = response.data;
        final othersRecipe = RecipeResponse.fromJson(dataJson);

        completion(othersRecipe);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }
}
