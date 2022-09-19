part of 'reSendActive_bloc.dart';

@immutable
class ReSendActiveEvent extends Equatable {
  const ReSendActiveEvent();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class CreateReSendActive extends ReSendActiveEvent {
  final String email;

  const CreateReSendActive(this.email);
}

class ReSendActiveSuccess extends ReSendActiveEvent {
  const ReSendActiveSuccess();
}

class ReSendActiveFailed extends ReSendActiveEvent {
  final ServerError error;
  const ReSendActiveFailed(this.error);
}
