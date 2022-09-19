part of 'verify_code_bloc.dart';

@immutable
class VerifyCodeEvent extends Equatable {
  const VerifyCodeEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CreateVerifyCodeEvent extends VerifyCodeEvent {
  final String email;
  final String code;
  const CreateVerifyCodeEvent(this.email, this.code);
}

class VerifyCodeSuccess extends VerifyCodeEvent {
  final String keyCode;
  const VerifyCodeSuccess(this.keyCode);
}

class VerifyCodeFailed extends VerifyCodeEvent {
  final ServerError error;
  const VerifyCodeFailed(this.error);
}
