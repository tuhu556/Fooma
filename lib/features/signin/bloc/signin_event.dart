part of 'signin_bloc.dart';

@immutable
class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object> get props => [];
}

class SignIn extends SignInEvent {
  final String email, password, deviceId;
  const SignIn(this.email, this.password, this.deviceId);
}

class SignInSuccess extends SignInEvent {
  final AuthenticationCredential data;
  const SignInSuccess(this.data);
}

class SignInBan extends SignInEvent {
  const SignInBan();
}

class SignInNotActive extends SignInEvent {
  const SignInNotActive();
}

class SignInFailed extends SignInEvent {
  final ServerError error;

  const SignInFailed(this.error);
}

class SignInWithGoogle extends SignInEvent {
  final String token, deviceId;
  const SignInWithGoogle(this.token, this.deviceId);
}

class SignInWithGoogleSuccess extends SignInEvent {
  final AuthenticationCredential data;
  const SignInWithGoogleSuccess(this.data);
}

class SignInWithGoogleFailed extends SignInEvent {
  final ServerError error;
  const SignInWithGoogleFailed(this.error);
}
