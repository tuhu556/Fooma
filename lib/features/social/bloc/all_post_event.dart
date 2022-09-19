part of 'all_post_bloc.dart';

@immutable
class AllPostEvent extends Equatable {
  const AllPostEvent();

  @override
  List<Object> get props => [];
}

class AllPost extends AllPostEvent {
  final int page;
  const AllPost(this.page);
}

class GetAllPostSuccess extends AllPostEvent {
  final MyPostResponse myPost;
  const GetAllPostSuccess(this.myPost);
}

class GetAllPostFailed extends AllPostEvent {
  final ServerError error;
  const GetAllPostFailed(this.error);
}
