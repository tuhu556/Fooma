part of 'change_pass_bloc.dart';

@immutable
class ChangePassEvent extends Equatable {
  const ChangePassEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CreateChangePassEvent extends ChangePassEvent {
  final String email;
  final String keyCode;
  final String password;
  const CreateChangePassEvent(this.email, this.keyCode, this.password);
}

class ChangePassSuccess extends ChangePassEvent {
  const ChangePassSuccess();
}

class ChangePassFailed extends ChangePassEvent {
  final ServerError error;
  const ChangePassFailed(this.error);
}
