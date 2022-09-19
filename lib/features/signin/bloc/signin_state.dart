// ignore_for_file: constant_identifier_names

part of 'signin_bloc.dart';

@immutable
class SignInState extends Equatable {
  final SignInStatus status;

  ServerError? error;

  AuthenticationCredential? data;

  SignInState({required this.status});

  @override
  List<Object> get props => [status];

  SignInState copyWith(SignInStatus? status, AuthenticationCredential? data,
      ServerError? error) {
    var newState = SignInState(status: status ?? this.status);

    if (data != null) {
      newState.data = data;
    }

    if (error != null) {
      newState.error = error;
    }

    return newState;
  }
}

enum SignInStatus {
  Initial,
  Processing,
  Success,
  Ban,
  Failed,
  WithGoogleInitial,
  WithGoogleProcessing,
  WithGoogleSuccess,
  WithGoogleFailed,
  NotActive,
}
