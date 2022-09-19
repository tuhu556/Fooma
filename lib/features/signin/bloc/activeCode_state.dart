part of 'activeCode_bloc.dart';

@immutable
class ActiveCodeState extends Equatable {
  final ActiveCodeStatus status;

  ServerError? error;

  AuthenticationCredential? data;

  ActiveCodeState({required this.status});

  @override
  List<Object> get props => [status];

  ActiveCodeState copyWith(ActiveCodeStatus? status,
      AuthenticationCredential? data, ServerError? error) {
    var newState = ActiveCodeState(status: status ?? this.status);

    if (data != null) {
      newState.data = data;
    }

    if (error != null) {
      newState.error = error;
    }

    return newState;
  }
}

enum ActiveCodeStatus { Initial, Processing, Success, Failed }
