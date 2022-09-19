part of 'favorite_post_bloc.dart';

@immutable
class MyFavoritePostState extends Equatable {
  final MyFavoritePostStatus status;

  MyFavoritePostResponse? myFavoritePost;
  MyPost? postDetail;

  ServerError? error;

  MyFavoritePostState({required this.status, this.postDetail});

  List<Object> get props => [status];

  MyFavoritePostState copyWith(
      MyFavoritePostStatus? status,
      MyFavoritePostResponse? myFavoritePost,
      MyPost? postDetail,
      ServerError? error) {
    var newState = MyFavoritePostState(status: status ?? this.status);

    if (myFavoritePost != null) {
      newState.myFavoritePost = myFavoritePost;
    }
    if (postDetail != null) {
      newState.postDetail = postDetail;
    }

    if (error != null) {
      newState.error = error;
    }

    return newState;
  }
}

enum MyFavoritePostStatus {
  SaveInitial,
  SaveProcessing,
  SaveSuccess,
  SaveFailed,
  UnSaveInitial,
  UnSaveProcessing,
  UnSaveSuccess,
  UnSaveFailed,
  Initial,
  Processing,
  Success,
  Failed,
  PostDetailInitial,
  PostDetailProcessing,
  PostDetailSuccess,
  PostDetailFailed,
}
