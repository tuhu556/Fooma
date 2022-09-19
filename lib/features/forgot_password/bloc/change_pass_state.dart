part of 'change_pass_bloc.dart';

@immutable
class ChangePassState extends Equatable {
  final ChangePassStatus status;
  Map<String, dynamic> createPasswordParameters = {};
  ServerError? error;

  ChangePassState({required this.status});

  List<Object> get props => [status];

  ChangePassState copyWith(ChangePassStatus? status, ServerError? error) {
    var newState = ChangePassState(status: status ?? this.status);

    newState.createPasswordParameters = createPasswordParameters;
    if (error != null) {
      newState.error = error;
    }

    return newState;
  }
}

enum ChangePassStatus {
  Initial,
  Processing,
  Success,
  Failed,
}
