part of 'verify_email_bloc.dart';

@immutable
class VerifyEmailState extends Equatable {
  final VerifyEmailStatus status;
  Map<String, dynamic> createEmailParameters = {};
  ServerError? error;

  VerifyEmailState({required this.status});

  List<Object> get props => [status];

  VerifyEmailState copyWith(VerifyEmailStatus? status, ServerError? error) {
    var newState = VerifyEmailState(status: status ?? this.status);

    newState.createEmailParameters = createEmailParameters;
    if (error != null) {
      newState.error = error;
    }

    return newState;
  }
}

enum VerifyEmailStatus {
  Initial,
  Processing,
  Success,
  Failed,
}
