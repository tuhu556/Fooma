part of 'change_password_bloc.dart';

@immutable
class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();

  @override
  List<Object> get props => [];
}

class ChangePassword extends ChangePasswordEvent {
  final String oldPassword;
  final String newPassword;
  const ChangePassword(this.oldPassword, this.newPassword);
}

class ChangePasswordSuccess extends ChangePasswordEvent {
  const ChangePasswordSuccess();
}

class ChangePasswordFailed extends ChangePasswordEvent {
  final ServerError error;
  const ChangePasswordFailed(this.error);
}
