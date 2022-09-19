part of 'upload_post_bloc.dart';

@immutable
class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class CreatePostEvent extends PostEvent {
  String? title;
  String? content;
  String? hashtag;
  List<PostImages>? postImages;
  // String? imageUrl;
  // bool? isThumbnail;

  CreatePostEvent({this.title, this.content, this.hashtag, this.postImages});
}

class CreatePostSuccess extends PostEvent {
  const CreatePostSuccess();
}

class CreatePostFailed extends PostEvent {
  final ServerError error;
  const CreatePostFailed(this.error);
}
