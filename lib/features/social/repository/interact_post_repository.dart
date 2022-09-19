import 'package:flutter/material.dart';
import 'package:foodhub/features/social/models/comment_entity.dart';
import '../../../service/networking.dart';
import 'package:foodhub/config/endpoint.dart';

import '../../favorite_post/models/favorite_post_entity.dart';

class InteractPostRepository extends Networking {
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

  void deleteMyPost(
    String id,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(HTTPMethod.Put,
        Path.shared.pathDeleteMyPost, null, {"id": id, "status": 0}, null);

    executeRequest(configuration, (response) {
      if (response.data != null) {
        final statusCode = response.data["code"];
        completion(statusCode);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }

  void getListPostComment(
    String postId,
    int page,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(
        HTTPMethod.Get,
        Path.shared.pathListPostComment,
        null,
        {"postId": postId, "page": page.toString(), "sortOption": "ASC"},
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

  void commentPost(
    Map<String, dynamic> params,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(
        HTTPMethod.Post, Path.shared.pathListPostComment, null, params, null);

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
    String postId,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(HTTPMethod.Delete,
        Path.shared.pathListPostComment + "/" + postId, null, null, null);

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
        Path.shared.pathListPostComment + "/" + commentId,
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

  void reactPost(
    String postId,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(HTTPMethod.Post,
        Path.shared.pathReactPost, null, {"postId": postId}, null);

    executeRequest(configuration, (response) {
      if (response.data != null) {
        final code = response.data["code"];
        completion(code);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }

  void unReactPost(
    String postId,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(HTTPMethod.Delete,
        Path.shared.pathReactPost, null, {"postId": postId}, null);

    executeRequest(configuration, (response) {
      if (response.data != null) {
        final code = response.data["code"];
        completion(code);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }

  void reportPost(
    Map<String, dynamic> params,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(
        HTTPMethod.Post, Path.shared.pathReportPost, null, params, null);

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
