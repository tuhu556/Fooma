part of 'reSendActive_bloc.dart';

@immutable
class ReSendActiveState extends Equatable {
  final ReSendActiveStatus status;

  ServerError? error;

  ReSendActiveState({required this.status});

  @override
  List<Object> get props => [status];

  ReSendActiveState copyWith(ReSendActiveStatus? status, ServerError? error) {
    var newState = ReSendActiveState(status: status ?? this.status);

    if (error != null) {
      newState.error = error;
    }

    return newState;
  }
}

enum ReSendActiveStatus { Initial, Processing, Success, Failed }
