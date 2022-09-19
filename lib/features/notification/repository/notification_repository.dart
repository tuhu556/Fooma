import 'package:flutter/material.dart';
import 'package:foodhub/features/notification/models/notification.dart';
import '../../../service/networking.dart';
import 'package:foodhub/config/endpoint.dart';

class AllNotiRestRepository extends Networking {
  void getAllNotification(
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(HTTPMethod.Get,
        Path.shared.pathGetAllNoti, null, {"size": "1000"}, null);

    executeRequest(configuration, (response) {
      if (response.data != null) {
        final dataJson = response.data;
        final listNoti = NotificationResponse.fromJson(dataJson);
        completion(listNoti);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }

  void getAllNotiSocial(
    int page,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(
        HTTPMethod.Get,
        Path.shared.pathGetAllNoti,
        null,
        {"page": page.toString(), "category": "SOCIAL"},
        null);

    executeRequest(configuration, (response) {
      if (response.data != null) {
        final dataJson = response.data;
        final listNoti = NotificationResponse.fromJson(dataJson);
        completion(listNoti);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }

  void getAllNotiIngredient(
    int page,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(
        HTTPMethod.Get,
        Path.shared.pathGetAllNoti,
        null,
        {"page": page.toString(), "category": "INGREDIENT"},
        null);

    executeRequest(configuration, (response) {
      if (response.data != null) {
        final dataJson = response.data;
        final listNoti = NotificationResponse.fromJson(dataJson);
        completion(listNoti);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }

  void getAllNotiPlan(
    int page,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(
        HTTPMethod.Get,
        Path.shared.pathGetAllNoti,
        null,
        {"page": page.toString(), "category": "PLAN"},
        null);

    executeRequest(configuration, (response) {
      if (response.data != null) {
        final dataJson = response.data;
        final listNoti = NotificationResponse.fromJson(dataJson);
        completion(listNoti);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }

  void markAsReadNoti(
    String id,
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(HTTPMethod.Put,
        Path.shared.pathGetAllNoti + "/" + id, null, null, null);

    executeRequest(configuration, (response) {
      if (response.data != null) {
        final token = response.data["code"];
        completion(token);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }
}
