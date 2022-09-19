part of 'edit_user_profile_bloc.dart';

@immutable
class EditUserProfileState extends Equatable {
  final EditUserProfileStatus status;
  String? token;
  Map<String, dynamic> updateUserParameters = {};

  ServerError? error;

  EditUserProfileState({required this.status});

  List<Object> get props => [status];

  EditUserProfileState copyWith(
      EditUserProfileStatus? status, ServerError? error) {
    var newState = EditUserProfileState(status: status ?? this.status);
    if (token != null) {
      newState.token = token;
    }
    newState.updateUserParameters = updateUserParameters;

    if (error != null) {
      newState.error = error;
    }

    return newState;
  }
}

enum EditUserProfileStatus {
  Initial,
  Processing,
  Success,
  Failed,
}
