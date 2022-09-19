import 'dart:convert';
import 'package:foodhub/session/session.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthenticationCredential {
  final String email;
  final String status;
  final String accessToken;
  final int accessTokenExpireIn;
  final String nameid;
  final String role;

  int authenticationTime = DateTime.now().millisecondsSinceEpoch;

  static final String credentialKey = "CREDENTIALS_KEY";

  AuthenticationCredential(
    this.accessToken,
    this.accessTokenExpireIn,
    this.email,
    this.status,
    this.nameid,
    this.role,
  );

  factory AuthenticationCredential.fromJson(String json) {
    final decodedToken = decode(json);
    final credential = AuthenticationCredential(
      json,
      decodedToken['exp'].toInt(),
      decodedToken['email'].toString(),
      decodedToken['status'].toString(),
      decodedToken['nameid'].toString(),
      decodedToken['role'].toString(),
    );
    credential.authenticationTime = DateTime.now().millisecondsSinceEpoch;
    // final authenticationTime = json["authenticationTime"];

    // if (authenticationTime != null) {
    //   credential.authenticationTime = authenticationTime;
    // }

    return credential;
  }

  static Future<AuthenticationCredential?> loadCredential() async {
    final prefs = await SharedPreferences.getInstance();

    final credentialString = prefs.get(credentialKey);

    if (credentialString != null &&
        credentialString != "" &&
        credentialString is String) {
      final json = jsonDecode(credentialString);

      return AuthenticationCredential.fromJson(json["token"]);
    }

    return null;
  }

  void storeCredential() {
    ApplicationSesson.shared.credential = this;

    authenticationTime = DateTime.now().millisecondsSinceEpoch;

    SharedPreferences.getInstance().then((prefs) => {_storeCredential(prefs)});
  }

  static void clearCredential() {
    SharedPreferences.getInstance().then((prefs) => {_clearCredential(prefs)});
  }

  static void _clearCredential(SharedPreferences prefs) {
    prefs.remove(credentialKey);
  }

  void _storeCredential(SharedPreferences prefs) {
    final Map<String, dynamic> map = {
      "token": accessToken,
      "expires_at": accessTokenExpireIn,
      "email": email,
      "nameid": nameid,
      "role": role,
    };

    prefs.setString(credentialKey, jsonEncode(map));
  }

  static Map<String, dynamic> decode(String token) {
    final splitToken = token.split("."); // Split the token by '.'
    if (splitToken.length != 3) {
      throw FormatException('Invalid token');
    }
    try {
      final payloadBase64 = splitToken[1]; // Payload is always the index 1
      // Base64 should be multiple of 4. Normalize the payload before decode it
      final normalizedPayload = base64.normalize(payloadBase64);
      // Decode payload, the result is a String
      final payloadString = utf8.decode(base64.decode(normalizedPayload));
      // Parse the String to a Map<String, dynamic>
      final decodedPayload = jsonDecode(payloadString);

      // Return the decoded payload
      return decodedPayload;
    } catch (error) {
      throw FormatException('Invalid payload');
    }
  }
}
