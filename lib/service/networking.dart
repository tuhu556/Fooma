// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodhub/config/endpoint.dart';
import 'package:foodhub/features/signin/models/signin_entity.dart';
import 'package:foodhub/session/session.dart';
import 'package:http/http.dart' as http;

class Networking {
  void executeRequest(RequestConfiguration configuration,
      ValueSetter<ServerResponse> completion) {
    configuration.headers ??= _defaultHeaders();

    final credential = ApplicationSesson.shared.credential;

    if (credential != null) {
      configuration.headers!["Bearer"] = "${credential.accessToken}";
      configuration.headers!["Authorization"] =
          "Bearer " + credential.accessToken;
    }

    print(configuration.headers);

    print(configuration.params);

    print(configuration.path);

    //check refresh token

    // if (configuration.path != "/authentication/refresh-token") {
    //   refreshToken();
    // }

    switch (configuration.method) {
      case HTTPMethod.Get:
        final url = Uri.https(
            Endpoint.shared.url, configuration.path, configuration.params);
        http
            .get(url, headers: configuration.headers)
            .then((value) => _handleResponse(value, completion))
            .onError((error, stackTrace) => _handleError(error, completion));
        break;

      case HTTPMethod.Post:
        final url = Uri.https(Endpoint.shared.url, configuration.path);

        http
            .post(url,
                body: json.encode(configuration.params),
                headers: configuration.headers)
            .then((value) => _handleResponse(value, completion))
            .onError((error, stackTrace) => _handleError(error, completion));
        break;

      case HTTPMethod.Put:
        final url = Uri.https(
          Endpoint.shared.url,
          configuration.path,
        );
        http
            .put(url,
                body: json.encode(configuration.params),
                headers: configuration.headers)
            .then((value) => _handleResponse(value, completion))
            .onError((error, stackTrace) => _handleError(error, completion));
        break;

      case HTTPMethod.Delete:
        final url = Uri.https(Endpoint.shared.url, configuration.path);
        http
            .delete(url,
                body: json.encode(configuration.params),
                headers: configuration.headers)
            .then((value) => _handleResponse(value, completion))
            .onError((error, stackTrace) => _handleError(error, completion));
        break;

      default:
        print("Did'nt implement this method");

        break;
    }
  }

  // void refreshToken() {
  //   final credential = ApplicationSesson.shared.credential;

  //   if (credential != null) {
  //     final deltaTime = (DateTime.now().millisecondsSinceEpoch -
  //             credential.authenticationTime) /
  //         1000;

  //     if (deltaTime > credential.accessTokenExpireIn - 1800 &&
  //         ApplicationSesson.shared.isRefreshingToken == false) {
  //       _refreshToken(credential);
  //     }
  //   }
  // }

  // void _refreshToken(AuthenticationCredential credential) {
  //   ApplicationSesson.shared.isRefreshingToken = true;

  //   final params = {"refreshToken": credential.refreshToken};

  //   final configuration = RequestConfiguration(
  //       HTTPMethod.Post, '/authentication/refresh-token', null, params, null);

  //   executeRequest(configuration, (response) {
  //     ApplicationSesson.shared.isRefreshingToken = false;

  //     if (response.data != null) {
  //       print("refresh token success");

  //       final dataJson = response.data["data"];

  //       final newCredential = AuthenticationCredential.fromJson(dataJson);

  //       newCredential.storeCredential();
  //     }
  //   });
  // }

  void _handleResponse(
      http.Response response, ValueSetter<ServerResponse> completion) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      final bodyJson = json.decode(response.body);

      print(bodyJson);
      print(response.statusCode);
      completion(ServerResponse(bodyJson, null));
    } else {
      final errorJson = json.decode(response.body);
      print(errorJson);
      final error = ServerError.fromJson(errorJson);
      completion(ServerResponse(null, error));
    }
  }

  void _handleError(Object? error, ValueSetter<ServerResponse> completion) {
    print(error!.toString());
    final e = ServerError.internalError();
    completion(ServerResponse(null, e));
  }

  Map<String, String> _defaultHeaders() {
    return {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8',
      "Access-Control-Allow-Origin": "*"
    };
  }
}

class ServerResponse {
  ServerError? error;

  dynamic? data;

  ServerResponse(this.data, this.error);
}

class ServerError extends Error {
  int? status;

  int code;

  String message;

  String? description;

  ServerError(
      {required this.code,
      required this.message,
      this.status,
      this.description});

  factory ServerError.fromJson(Map<String, dynamic> json) {
    var statusCode = 400;
    var code = 7;

    const message = "Xử lý dữ liệu không thành công";

    if (json["status"] != null) {
      statusCode = json["status"] as int;
    }

    if (json["code"] != null) {
      code = json["code"] as int;
    }

    final error = ServerError(code: code, message: message);

    error.status = statusCode;
    return error;
  }

  factory ServerError.internalError() {
    return ServerError(code: 7, message: "Xử lý dữ liệu không thành công");
  }
}

enum HTTPMethod { Get, Post, Put, Delete }

class RequestConfiguration {
  final HTTPMethod method;

  final String path;

  Map<String, String>? headers;

  Map<String, dynamic>? params;

  AuthenticationCredential? credential;

  RequestConfiguration(
      this.method, this.path, this.headers, this.params, this.credential);
}
