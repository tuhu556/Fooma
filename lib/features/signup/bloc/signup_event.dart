part of 'signup_bloc.dart';

@immutable
class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CreateSignUpEvent extends SignUpEvent {
  String? email;
  String? name;
  String? password;
  CreateSignUpEvent({this.email, this.name, this.password});
}

class CreateSignUpSuccess extends SignUpEvent {
  const CreateSignUpSuccess();
}

class CreateSignUpDulicated extends SignUpEvent {
  const CreateSignUpDulicated();
}

class CreateSignUpFailed extends SignUpEvent {
  final ServerError error;
  const CreateSignUpFailed(this.error);
}
