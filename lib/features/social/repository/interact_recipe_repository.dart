import 'package:flutter/material.dart';
import 'package:foodhub/features/social/models/method_recipe_entity.dart';
import 'package:foodhub/features/social/models/recipe_entity.dart';
import '../../../service/networking.dart';
import 'package:foodhub/config/endpoint.dart';

import '../models/comment_entity.dart';

class InteractRecipeRepository extends Networking {
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

  void getMyFavoriteRecipe(
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(HTTPMethod.Get,
        Path.shared.pathFavoriteRecipe, null, {"size": "1000"}, null);

    executeRequest(configuration, (response) {
      if (response.data != null) {
        final dataJson = response.data;
        final myFavoriteRecipe = RecipeResponse.fromJson(dataJson);

        completion(myFavoriteRecipe);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }

  void deleteMyRecipe(
    String id,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(HTTPMethod.Delete,
        Path.shared.pathDeleteMyRecipe + "/" + id, null, null, null);

    executeRequest(configuration, (response) {
      if (response.data != null) {
        final statusCode = response.data["code"];
        completion(statusCode);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }

  void getListRecipeComment(
    String recipeId,
    int page,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(
        HTTPMethod.Get,
        Path.shared.pathListRecipeComment,
        null,
        {"id": recipeId, "page": page.toString(), "sortOption": "ASC"},
        null);

    executeRequest(configuration, (response) {
      if (response.data != null) {
        final dataJson = response.data;
        final listPostComment = CommentResponse.fromJson(dataJson);

        completion(listPostComment);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }

  void commentRecipe(
    Map<String, dynamic> params,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(
        HTTPMethod.Post, Path.shared.pathListRecipeComment, null, params, null);

    executeRequest(configuration, (response) {
      if (response.data != null) {
        final code = response.data["code"];
        completion(code);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }

  void deleteComment(
    String recipeId,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(HTTPMethod.Delete,
        Path.shared.pathListRecipeComment + "/" + recipeId, null, null, null);

    executeRequest(configuration, (response) {
      if (response.data != null) {
        final code = response.data["code"];
        completion(code);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }

  void editComment(
    String content,
    String commentId,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(
        HTTPMethod.Put,
        Path.shared.pathListRecipeComment + "/" + commentId,
        null,
        {"content": content},
        null);

    executeRequest(configuration, (response) {
      if (response.data != null) {
        final code = response.data["code"];
        completion(code);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }

  void reactRecipe(
    String recipeId,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(HTTPMethod.Post,
        Path.shared.pathReactRecipe, null, {"recipeId": recipeId}, null);

    executeRequest(configuration, (response) {
      if (response.data != null) {
        final code = response.data["code"];
        completion(code);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }

  void unReactRecipe(
    String recipeId,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(HTTPMethod.Delete,
        Path.shared.pathReactRecipe, null, {"recipeId": recipeId}, null);

    executeRequest(configuration, (response) {
      if (response.data != null) {
        final code = response.data["code"];
        completion(code);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }

  void getListMethodRecipe(
    String recipeId,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(HTTPMethod.Get,
        Path.shared.pathRecipe + "/" + recipeId, null, null, null);

    executeRequest(configuration, (response) {
      if (response.data != null) {
        final dataJson = response.data;
        final lsitMethodRecipe = MethodRecipeResponse.fromJson(dataJson);

        completion(lsitMethodRecipe);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }

  void reportRecipe(
    Map<String, dynamic> params,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(
        HTTPMethod.Post, Path.shared.pathReportRecipe, null, params, null);

    executeRequest(configuration, (response) {
      if (response.data != null) {
        final code = response.data["code"];
        completion(code);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }

  void ratingRecipe(
    Map<String, dynamic> params,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(
        HTTPMethod.Post, Path.shared.pathRatingRecipe, null, params, null);

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
