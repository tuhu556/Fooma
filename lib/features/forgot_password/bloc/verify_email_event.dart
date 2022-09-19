part of 'verify_email_bloc.dart';

@immutable
class VerifyEmailEvent extends Equatable {
  const VerifyEmailEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CreateVerifyEmailEvent extends VerifyEmailEvent {
  String? email;

  CreateVerifyEmailEvent(this.email);
}

class VerifyEmailSuccess extends VerifyEmailEvent {
  const VerifyEmailSuccess();
}

class VerifyEmailFailed extends VerifyEmailEvent {
  final ServerError error;
  const VerifyEmailFailed(this.error);
}
