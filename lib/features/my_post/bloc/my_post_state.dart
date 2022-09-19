part of 'my_post_bloc.dart';

@immutable
class EditMyPostState extends Equatable {
  final EditMyPostStatus status;
  Map<String, dynamic> editMyPostParameters = {};
  ServerError? error;

  EditMyPostState({required this.status});

  List<Object> get props => [status];

  EditMyPostState copyWith(EditMyPostStatus? status, ServerError? error) {
    var newState = EditMyPostState(status: status ?? this.status);

    newState.editMyPostParameters = editMyPostParameters;

    if (error != null) {
      newState.error = error;
    }

    return newState;
  }
}

enum EditMyPostStatus {
  Initial,
  Processing,
  Success,
  Failed,
  DeleteInitial,
  DeleteProcessing,
  DeleteSuccess,
  DeleteFailed,
}
