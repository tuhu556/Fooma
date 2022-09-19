import 'package:flutter/material.dart';
import 'package:foodhub/features/social/models/recipe_entity.dart';
import 'package:foodhub/features/user_profile/model/my_post_entity.dart';
import 'package:foodhub/features/user_profile/model/user_profile_entity.dart';

import '../../../service/networking.dart';
import 'package:foodhub/config/endpoint.dart';

class UserProfileRestRepository extends Networking {
  void getUserProfile(
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(
        HTTPMethod.Get, Path.shared.pathGetUserProfile, null, null, null);

    executeRequest(configuration, (response) {
      var dataJson = null;
      if (response.data != null) {
        if (response.data["code"] == 1412) {
          dataJson = response.data["code"];
          completion(dataJson);
        } else {
          dataJson = response.data;
          final userProfile = UserProfileResponse.fromJson(dataJson);
          completion(userProfile);
        }
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }
}

class MyPostRestRepository extends Networking {
  void getMyPost(
    int page,
    int status,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(
        HTTPMethod.Get,
        Path.shared.pathGetMyPost,
        null,
        {"status": status.toString(), "page": page.toString()},
        null);

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

  void getMyPostPending(
    int page,
    int status,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(
        HTTPMethod.Get,
        Path.shared.pathGetMyPost,
        null,
        {"status": status.toString(), "page": page.toString()},
        null);

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

  void getMyPostDenied(
    int page,
    int status,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(
        HTTPMethod.Get,
        Path.shared.pathGetMyPost,
        null,
        {"status": status.toString(), "page": page.toString()},
        null);

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

  void getMyRecipe(
    int page,
    int status,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(
        HTTPMethod.Get,
        Path.shared.pathGetMyRecipe,
        null,
        {"status": status.toString(), "page": page.toString()},
        null);

    executeRequest(configuration, (response) {
      if (response.data != null) {
        final dataJson = response.data;
        final myRecipe = RecipeResponse.fromJson(dataJson);

        completion(myRecipe);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }

  void getMyRecipePending(
    int page,
    int status,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(
        HTTPMethod.Get,
        Path.shared.pathGetMyRecipe,
        null,
        {"status": status.toString(), "page": page.toString()},
        null);

    executeRequest(configuration, (response) {
      if (response.data != null) {
        final dataJson = response.data;
        final myPost = RecipeResponse.fromJson(dataJson);

        completion(myPost);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }

  void getMyRecipeDenied(
    int page,
    int status,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(
        HTTPMethod.Get,
        Path.shared.pathGetMyRecipe,
        null,
        {"status": status.toString(), "page": page.toString()},
        null);

    executeRequest(configuration, (response) {
      if (response.data != null) {
        final dataJson = response.data;
        final myPost = RecipeResponse.fromJson(dataJson);

        completion(myPost);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }
}
