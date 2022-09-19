import 'package:foodhub/features/signin/models/signin_entity.dart';

class ApplicationSesson {
  static final ApplicationSesson shared = ApplicationSesson._internal();

  factory ApplicationSesson() {
    return shared;
  }

  ApplicationSesson._internal();

  AuthenticationCredential? credential;

  // Load information when initial app here, success setting, credetial

  Future<bool> loadSession() async {
    credential = await AuthenticationCredential.loadCredential();

    return true;
  }

  void clearSession() {
    credential = null;

    AuthenticationCredential.clearCredential();
  }

  bool isRefreshingToken = false;
}
