part of 'upload_post_bloc.dart';

@immutable
class PostState extends Equatable {
  final PostStatus status;
  Map<String, dynamic> createPostParameters = {};
  ServerError? error;

  PostState({required this.status});

  List<Object> get props => [status];

  PostState copyWith(PostStatus? status, ServerError? error) {
    var newState = PostState(status: status ?? this.status);

    newState.createPostParameters = createPostParameters;

    if (error != null) {
      newState.error = error;
    }

    return newState;
  }
}

enum PostStatus {
  Initial,
  Processing,
  Success,
  Failed,
}
