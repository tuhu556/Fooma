part of 'interact_post_bloc.dart';

@immutable
class InteractPostState extends Equatable {
  final InteractPostStatus status;
  ServerError? error;
  MyFavoritePostResponse? myFavoritePost;
  CommentResponse? commentPost;
  Map<String, dynamic> commentParameters = {};
  Map<String, dynamic> reportParameters = {};
  int? code;
  InteractPostState({required this.status});

  List<Object> get props => [status];

  InteractPostState copyWith(
      InteractPostStatus? status,
      MyFavoritePostResponse? myFavoritePost,
      CommentResponse? commentResponse,
      int? code,
      ServerError? error) {
    var newState = InteractPostState(status: status ?? this.status);
    if (myFavoritePost != null) {
      newState.myFavoritePost = myFavoritePost;
    }
    if (commentResponse != null) {
      newState.commentPost = commentResponse;
    }

    if (code != null) {
      newState.code = code;
    }
    newState.commentParameters = commentParameters;
    newState.reportParameters = reportParameters;
    if (error != null) {
      newState.error = error;
    }

    return newState;
  }
}

enum InteractPostStatus {
  SaveInitial,
  SaveProcessing,
  SaveSuccess,
  SaveFailed,
  UnSaveInitial,
  UnSaveProcessing,
  UnSaveSuccess,
  UnSaveFailed,
  FavoriteInitial,
  FavoriteProcessing,
  FavoriteSuccess,
  FavoriteFailed,
  DeleteInitial,
  DeleteProcessing,
  DeleteSuccess,
  DeleteFailed,
  ListCommentInitial,
  ListCommentProcessing,
  ListCommentSuccess,
  ListCommentFailed,
  CommentInitial,
  CommentProcessing,
  CommentSuccess,
  CommentFailed,
  DeleteCommentInitial,
  DeleteCommentProcessing,
  DeleteCommentSuccess,
  DeleteCommentFailed,
  EditCommentInitial,
  EditCommentProcessing,
  EditCommentSuccess,
  EditCommentFailed,
  ReactPostInitial,
  ReactPostProcessing,
  ReactPostSuccess,
  ReactPostFailed,
  UnReactPostInitial,
  UnReactPostProcessing,
  UnReactPostSuccess,
  UnReactPostFailed,
  ReportPostInitial,
  ReportPostProcessing,
  ReportPostSuccess,
  ReportPostFailed,
}
