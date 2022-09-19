part of 'favorite_post_bloc.dart';

@immutable
class MyFavoritePostEvent extends Equatable {
  const MyFavoritePostEvent();

  @override
  List<Object> get props => [];
}

class MyFavoritePost extends MyFavoritePostEvent {
  const MyFavoritePost();
}

class GetMyFavoritePostDetailSuccess extends MyFavoritePostEvent {
  final MyFavoritePostResponse data;
  const GetMyFavoritePostDetailSuccess(this.data);
}

class GetMyFavoritePostDetailFailed extends MyFavoritePostEvent {
  final ServerError error;
  const GetMyFavoritePostDetailFailed(this.error);
}

class SavePost extends MyFavoritePostEvent {
  String postId;
  SavePost(this.postId);
}

class SavePostSuccess extends MyFavoritePostEvent {
  const SavePostSuccess();
}

class SavePostFailed extends MyFavoritePostEvent {
  final ServerError error;
  const SavePostFailed(this.error);
}

class UnSavePost extends MyFavoritePostEvent {
  String postId;
  UnSavePost(this.postId);
}

class UnSavePostSuccess extends MyFavoritePostEvent {
  const UnSavePostSuccess();
}

class UnSavePostFailed extends MyFavoritePostEvent {
  final ServerError error;
  const UnSavePostFailed(this.error);
}

class GetPostDetail extends MyFavoritePostEvent {
  final String postId;
  const GetPostDetail(this.postId);
}

class GetPostDetailSuccess extends MyFavoritePostEvent {
  final MyPost data;
  const GetPostDetailSuccess(this.data);
}

class GetPostDetailFailed extends MyFavoritePostEvent {
  final ServerError error;
  const GetPostDetailFailed(this.error);
}
