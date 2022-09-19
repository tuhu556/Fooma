part of 'signup_bloc.dart';

@immutable
class SignUpState extends Equatable {
  final SignUpStatus status;
  Map<String, dynamic> createSignUpParameters = {};
  ServerError? error;

  SignUpState({required this.status});

  List<Object> get props => [status];

  SignUpState copyWith(SignUpStatus? status, ServerError? error) {
    var newState = SignUpState(status: status ?? this.status);

    newState.createSignUpParameters = createSignUpParameters;
    if (error != null) {
      newState.error = error;
    }

    return newState;
  }
}

enum SignUpStatus {
  Initial,
  Processing,
  Success,
  Failed,
  Duplicated,
}
