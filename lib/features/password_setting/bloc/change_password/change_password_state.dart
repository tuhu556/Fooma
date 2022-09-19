part of 'change_password_bloc.dart';

@immutable
class ChangePasswordState extends Equatable {
  final ChangePasswordStatus status;
  Map<String, dynamic> createParameters = {};
  ServerError? error;
  ChangePasswordState({required this.status});

  @override
  List<Object> get props => [status];
  ChangePasswordState copyWith(
      ChangePasswordStatus? status, ServerError? error) {
    var newState = ChangePasswordState(status: status ?? this.status);

    newState.createParameters = createParameters;

    if (error != null) {
      newState.error = error;
    }

    return newState;
  }
}

enum ChangePasswordStatus {
  Initial,
  Processing,
  Success,
  Failed,
}
