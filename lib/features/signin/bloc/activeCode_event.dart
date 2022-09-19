part of 'activeCode_bloc.dart';

@immutable
class ActiveCodeEvent extends Equatable {
  const ActiveCodeEvent();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class ActiveCode extends ActiveCodeEvent {
  final String email, activeCode;

  const ActiveCode(this.email, this.activeCode);
}

class ActiveCodeSuccess extends ActiveCodeEvent {
  final AuthenticationCredential data;
  const ActiveCodeSuccess(this.data);
}

class ActiveCodeFailed extends ActiveCodeEvent {
  final ServerError error;
  const ActiveCodeFailed(this.error);
}
