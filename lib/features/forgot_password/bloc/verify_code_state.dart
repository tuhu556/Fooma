part of 'verify_code_bloc.dart';

@immutable
class VerifyCodeState extends Equatable {
  final VerifyCodeStatus status;
  Map<String, dynamic> createCodeParameters = {};
  ServerError? error;
  String? keyCode;
  VerifyCodeState({required this.status});

  List<Object> get props => [status];

  VerifyCodeState copyWith(
    VerifyCodeStatus? status,
    String? keyCode,
    ServerError? error,
  ) {
    var newState = VerifyCodeState(status: status ?? this.status);

    newState.createCodeParameters = createCodeParameters;
    if (keyCode != null) {
      newState.keyCode = keyCode;
    }
    if (error != null) {
      newState.error = error;
    }

    return newState;
  }
}

enum VerifyCodeStatus {
  Initial,
  Processing,
  Success,
  Failed,
}
