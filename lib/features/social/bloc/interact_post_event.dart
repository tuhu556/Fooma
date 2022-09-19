part of 'interact_post_bloc.dart';

@immutable
class InteractPostEvent extends Equatable {
  const InteractPostEvent();

  @override
  List<Object> get props => [];
}

class SavePostSocial extends InteractPostEvent {
  String postId;
  SavePostSocial(this.postId);
}

class SavePostSocialSuccess extends InteractPostEvent {
  const SavePostSocialSuccess();
}

class SavePostSocialFailed extends InteractPostEvent {
  final ServerError error;
  const SavePostSocialFailed(this.error);
}

class UnSavePostSocial extends InteractPostEvent {
  String postId;
  UnSavePostSocial(this.postId);
}

class UnSavePostSocialSuccess extends InteractPostEvent {
  const UnSavePostSocialSuccess();
}

class UnSavePostSocialFailed extends InteractPostEvent {
  final ServerError error;
  const UnSavePostSocialFailed(this.error);
}

class MyFavoriteSocialPost extends InteractPostEvent {
  const MyFavoriteSocialPost();
}

class GetMyFavoritePostDetailSuccess extends InteractPostEvent {
  final MyFavoritePostResponse data;
  const GetMyFavoritePostDetailSuccess(this.data);
}

class GetMyFavoritePostDetailFailed extends InteractPostEvent {
  final ServerError error;
  const GetMyFavoritePostDetailFailed(this.error);
}

class DeleteMyPost extends InteractPostEvent {
  final String id;

  const DeleteMyPost({
    required this.id,
  });
}

class DeleteMyPostSuccess extends InteractPostEvent {
  const DeleteMyPostSuccess();
}

class DeleteMyPostFailed extends InteractPostEvent {
  final ServerError error;
  const DeleteMyPostFailed(this.error);
}

class ListPostComment extends InteractPostEvent {
  final String postId;
  final int page;
  const ListPostComment(this.postId, this.page);
}

class ListPostCommentSuccess extends InteractPostEvent {
  final CommentResponse comment;
  const ListPostCommentSuccess(this.comment);
}

class ListPostCommentFailed extends InteractPostEvent {
  final ServerError error;
  const ListPostCommentFailed(this.error);
}

class CommentPost extends InteractPostEvent {
  final String postId;
  final String content;
  const CommentPost(this.postId, this.content);
}

class CommentSuccess extends InteractPostEvent {
  const CommentSuccess();
}

class CommentFailed extends InteractPostEvent {
  final ServerError error;
  const CommentFailed(this.error);
}

class DeleteCommentPost extends InteractPostEvent {
  final String postId;
  const DeleteCommentPost(this.postId);
}

class DeleteCommentSuccess extends InteractPostEvent {
  const DeleteCommentSuccess();
}

class DeleteCommentFailed extends InteractPostEvent {
  final ServerError error;
  const DeleteCommentFailed(this.error);
}

class EditCommentPost extends InteractPostEvent {
  final String commentId;
  final String content;
  const EditCommentPost(this.commentId, this.content);
}

class EditCommentSuccess extends InteractPostEvent {
  const EditCommentSuccess();
}

class EditCommentFailed extends InteractPostEvent {
  final ServerError error;
  const EditCommentFailed(this.error);
}

class ReactPost extends InteractPostEvent {
  final String postId;
  const ReactPost(this.postId);
}

class ReactPostSuccess extends InteractPostEvent {
  final int code;
  const ReactPostSuccess(this.code);
}

class ReactPostFailed extends InteractPostEvent {
  final ServerError error;
  const ReactPostFailed(this.error);
}

class UnReactPost extends InteractPostEvent {
  final String postId;
  const UnReactPost(this.postId);
}

class UnReactPostSuccess extends InteractPostEvent {
  final int code;
  const UnReactPostSuccess(this.code);
}

class UnReactPostFailed extends InteractPostEvent {
  final ServerError error;
  const UnReactPostFailed(this.error);
}

class ReportPost extends InteractPostEvent {
  final String postId;
  final String title;
  final String content;
  const ReportPost(this.postId, this.title, this.content);
}

class ReportPostSuccess extends InteractPostEvent {
  const ReportPostSuccess();
}

class ReportPostFailed extends InteractPostEvent {
  final ServerError error;
  const ReportPostFailed(this.error);
}
