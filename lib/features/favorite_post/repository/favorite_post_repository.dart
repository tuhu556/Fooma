import 'package:flutter/material.dart';
import 'package:foodhub/features/favorite_post/models/favorite_post_entity.dart';
import 'package:foodhub/features/user_profile/model/my_post_entity.dart';

import '../../../service/networking.dart';
import 'package:foodhub/config/endpoint.dart';

import '../models/favorite_recipe_entity.dart';

class MyFavoritePostRestRepository extends Networking {
  void getMyFavoritePost(
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(HTTPMethod.Get,
        Path.shared.pathFavoritePost, null, {"size": "1000"}, null);

    executeRequest(configuration, (response) {
      if (response.data != null) {
        final dataJson = response.data;
        final myFavoritePost = MyFavoritePostResponse.fromJson(dataJson);

        completion(myFavoritePost);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }

  void getPostById(
    String postId,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(HTTPMethod.Get,
        Path.shared.pathGetAllPost + "/" + postId, null, null, null);

    executeRequest(configuration, (response) {
      if (response.data != null) {
        final dataJson = response.data;
        final postDetail = MyPost.fromJson(dataJson);

        completion(postDetail);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }

  void savePost(
    String postId,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(HTTPMethod.Post,
        Path.shared.pathSavePost, null, {"postId": postId}, null);

    executeRequest(configuration, (response) {
      if (response.data != null) {
        final statusCode = response.data["code"];
        completion(statusCode);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }

  void unSavePost(
    String postId,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(HTTPMethod.Put,
        Path.shared.pathUnSavePost, null, {"postId": postId}, null);

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

class MyFavoriteRecipeRestRepository extends Networking {
  void getMyFavoriteRecipe(
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(HTTPMethod.Get,
        Path.shared.pathFavoriteRecipe, null, {"size": "1000"}, null);

    executeRequest(configuration, (response) {
      if (response.data != null) {
        final dataJson = response.data;
        final myFavoriteRecipe = MyFavoriteRecipeResponse.fromJson(dataJson);

        completion(myFavoriteRecipe);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }

  void getRecipeById(
    String recipeId,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(HTTPMethod.Get,
        Path.shared.pathGetAllRecipe + "/" + recipeId, null, null, null);

    executeRequest(configuration, (response) {
      if (response.data != null) {
        final dataJson = response.data;
        final recipeDetail = Recipe.fromJson(dataJson);

        completion(recipeDetail);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }

  void saveRecipe(
    String recipeId,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(HTTPMethod.Post,
        Path.shared.pathSaveRecipe, null, {"recipeId": recipeId}, null);

    executeRequest(configuration, (response) {
      if (response.data != null) {
        final statusCode = response.data["code"];
        completion(statusCode);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }

  void unSaveRecipe(
    String recipeId,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(HTTPMethod.Put,
        Path.shared.pathUnSaveRecipe, null, {"recipeId": recipeId}, null);

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
