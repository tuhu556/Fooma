part of 'all_post_bloc.dart';

@immutable
class AllPostState extends Equatable {
  final AllPostStatus status;

  MyPostResponse? allPost;

  ServerError? error;

  AllPostState({required this.status});

  List<Object> get props => [status];

  AllPostState copyWith(
      AllPostStatus? status, MyPostResponse? allPost, ServerError? error) {
    var newState = AllPostState(status: status ?? this.status);

    if (allPost != null) {
      newState.allPost = allPost;
    }

    if (error != null) {
      newState.error = error;
    }

    return newState;
  }
}

enum AllPostStatus {
  Initial,
  Processing,
  Success,
  Failed,
}
