import 'package:flutter/material.dart';
import 'package:foodhub/config/endpoint.dart';
import 'package:foodhub/features/signin/models/signin_entity.dart';
import 'package:foodhub/service/networking.dart';

class SignInRestRepository extends Networking {
  void signIn(
    String email,
    String password,
    String deviceId,
    ValueSetter<dynamic> completion,
  ) {
    final params = {"email": email, "password": password, "deviceId": deviceId};

    final configuration = RequestConfiguration(
        HTTPMethod.Post, Path.shared.pathSignIn, null, params, null);

    executeRequest(configuration, (response) {
      if (response.data != null) {
        final dataJson = response.data["token"];
        if (dataJson == null) {
          final statusCode = response.data["code"];
          completion(statusCode);
        } else {
          final signInResponse = AuthenticationCredential.fromJson(dataJson);
          completion(signInResponse);
        }
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }

  void signInWithGoogle(
    String token,
    String deviceId,
    ValueSetter<dynamic> completion,
  ) {
    final params = {"token": token, "deviceId": deviceId};

    final configuration = RequestConfiguration(
        HTTPMethod.Post, Path.shared.pathSignInWithGoogle, null, params, null);

    executeRequest(configuration, (response) {
      if (response.data != null) {
        final dataJson = response.data["token"];
        final signInResponse = AuthenticationCredential.fromJson(dataJson);

        completion(signInResponse);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }
}
