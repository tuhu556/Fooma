part of 'my_post_bloc.dart';

@immutable
class EditMyPostEvent extends Equatable {
  const EditMyPostEvent();

  @override
  List<Object> get props => [];
}

class EditMyPost extends EditMyPostEvent {
  String? id;
  String? title;
  String? content;
  String? hashtag;
  List<EditImageList>? postImages;

  EditMyPost({
    this.id,
    this.title,
    this.content,
    this.hashtag,
    this.postImages,
  });
}

class EditMyPostSuccess extends EditMyPostEvent {
  const EditMyPostSuccess();
}

class EditMyPostFailed extends EditMyPostEvent {
  final ServerError error;
  const EditMyPostFailed(this.error);
}
