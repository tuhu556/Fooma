import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';

import 'package:flutter/material.dart';
import 'package:foodhub/features/social/models/comment_entity.dart';
import 'package:foodhub/features/social/repository/interact_post_repository.dart';

import '../../../service/networking.dart';
import '../../favorite_post/models/favorite_post_entity.dart';
import '../../favorite_post/repository/favorite_post_repository.dart';
part 'interact_post_event.dart';

part 'interact_post_state.dart';

class InteractPostBloc extends Bloc<InteractPostEvent, InteractPostState> {
  InteractPostBloc()
      : super(InteractPostState(status: InteractPostStatus.SaveInitial));

  @override
  Stream<InteractPostState> mapEventToState(
    InteractPostEvent event,
  ) async* {
    if (event is SavePostSocial) {
      yield state.copyWith(
          InteractPostStatus.SaveProcessing, null, null, null, null);
      yield* _mapSavePostToState(event);
    } else if (event is SavePostSocialSuccess) {
      yield state.copyWith(
          InteractPostStatus.SaveSuccess, null, null, null, null);
    } else if (event is SavePostSocialFailed) {
      yield state.copyWith(
          InteractPostStatus.SaveFailed, null, null, null, event.error);
    } else if (event is UnSavePostSocial) {
      yield state.copyWith(
          InteractPostStatus.UnSaveProcessing, null, null, null, null);
      yield* _mapUnSavePostToState(event);
    } else if (event is UnSavePostSocialSuccess) {
      yield state.copyWith(
          InteractPostStatus.UnSaveSuccess, null, null, null, null);
    } else if (event is UnSavePostSocialFailed) {
      yield state.copyWith(
          InteractPostStatus.UnSaveFailed, null, null, null, event.error);
    } else if (event is MyFavoriteSocialPost) {
      yield state.copyWith(
          InteractPostStatus.FavoriteProcessing, null, null, null, null);
      yield* _mapGetMyFavoritePostToState(event);
    } else if (event is GetMyFavoritePostDetailSuccess) {
      yield state.copyWith(
          InteractPostStatus.FavoriteSuccess, event.data, null, null, null);
    } else if (event is GetMyFavoritePostDetailFailed) {
      yield state.copyWith(
          InteractPostStatus.FavoriteFailed, null, null, null, event.error);
    } //!
    else if (event is DeleteMyPost) {
      yield state.copyWith(
          InteractPostStatus.DeleteProcessing, null, null, null, null);
      yield* _mapDeleteMyPostState(event);
    } else if (event is DeleteMyPostSuccess) {
      yield state.copyWith(
          InteractPostStatus.DeleteSuccess, null, null, null, null);
    } else if (event is DeleteMyPostFailed) {
      yield state.copyWith(
          InteractPostStatus.DeleteFailed, null, null, null, event.error);
    } //!
    else if (event is ListPostComment) {
      yield state.copyWith(
          InteractPostStatus.ListCommentProcessing, null, null, null, null);
      yield* _mapGetListPostCommentToState(event);
    } else if (event is ListPostCommentSuccess) {
      yield state.copyWith(InteractPostStatus.ListCommentSuccess, null,
          event.comment, null, null);
    } else if (event is ListPostCommentFailed) {
      yield state.copyWith(
          InteractPostStatus.ListCommentFailed, null, null, null, event.error);
    }
    //!
    else if (event is CommentPost) {
      yield state.copyWith(
          InteractPostStatus.CommentProcessing, null, null, null, null);
      yield* _mapCommentPostState(event);
    } else if (event is CommentSuccess) {
      yield state.copyWith(
          InteractPostStatus.CommentSuccess, null, null, null, null);
    } else if (event is CommentFailed) {
      yield state.copyWith(
          InteractPostStatus.CommentFailed, null, null, null, event.error);
    }
    //!
    else if (event is DeleteCommentPost) {
      yield state.copyWith(
          InteractPostStatus.DeleteCommentProcessing, null, null, null, null);
      yield* _mapDeleteCommentPostState(event);
    } else if (event is DeleteCommentSuccess) {
      yield state.copyWith(
          InteractPostStatus.DeleteCommentSuccess, null, null, null, null);
    } else if (event is DeleteCommentFailed) {
      yield state.copyWith(InteractPostStatus.DeleteCommentFailed, null, null,
          null, event.error);
    }

    //!
    else if (event is EditCommentPost) {
      yield state.copyWith(
          InteractPostStatus.EditCommentProcessing, null, null, null, null);
      yield* _mapEditCommentPostState(event);
    } else if (event is EditCommentSuccess) {
      yield state.copyWith(
          InteractPostStatus.EditCommentSuccess, null, null, null, null);
    } else if (event is EditCommentFailed) {
      yield state.copyWith(
          InteractPostStatus.EditCommentFailed, null, null, null, event.error);
    }
    //!
    else if (event is ReactPost) {
      yield state.copyWith(
          InteractPostStatus.ReactPostProcessing, null, null, null, null);
      yield* _mapReactPostState(event);
    } else if (event is ReactPostSuccess) {
      yield state.copyWith(
          InteractPostStatus.ReactPostSuccess, null, null, event.code, null);
    } else if (event is ReactPostFailed) {
      yield state.copyWith(
          InteractPostStatus.ReactPostFailed, null, null, null, event.error);
    }
    //!
    else if (event is UnReactPost) {
      yield state.copyWith(
          InteractPostStatus.UnReactPostProcessing, null, null, null, null);
      yield* _mapUnReactPostState(event);
    } else if (event is UnReactPostSuccess) {
      yield state.copyWith(
          InteractPostStatus.UnReactPostSuccess, null, null, event.code, null);
    } else if (event is UnReactPostFailed) {
      yield state.copyWith(
          InteractPostStatus.UnReactPostFailed, null, null, null, event.error);
    }
    //!
    else if (event is ReportPost) {
      yield state.copyWith(
          InteractPostStatus.ReportPostProcessing, null, null, null, null);
      yield* _mapReportPostState(event);
    } else if (event is ReportPostSuccess) {
      yield state.copyWith(
          InteractPostStatus.ReportPostSuccess, null, null, null, null);
    } else if (event is ReportPostFailed) {
      yield state.copyWith(
          InteractPostStatus.ReportPostFailed, null, null, null, event.error);
    }
  }

  Stream<InteractPostState> _mapSavePostToState(SavePostSocial event) async* {
    final repository = InteractPostRepository();

    try {
      repository.savePost(event.postId, (data) {
        if (data is int && (data == 200) || data == 204) {
          add(const SavePostSocialSuccess());
        } else {
          add(SavePostSocialFailed(data as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(InteractPostStatus.SaveFailed, null, null, null,
          ServerError.internalError());
    }
  }

  Stream<InteractPostState> _mapUnSavePostToState(
      UnSavePostSocial event) async* {
    final repository = InteractPostRepository();

    try {
      repository.unSavePost(event.postId, (data) {
        if (data is int && (data == 200) || data == 204) {
          add(const UnSavePostSocialSuccess());
        } else {
          add(UnSavePostSocialFailed(data as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(InteractPostStatus.UnSaveFailed, null, null, null,
          ServerError.internalError());
    }
  }

  Stream<InteractPostState> _mapGetMyFavoritePostToState(
      MyFavoriteSocialPost event) async* {
    final repository = MyFavoritePostRestRepository();

    try {
      repository.getMyFavoritePost((value) {
        if (value is MyFavoritePostResponse) {
          add(GetMyFavoritePostDetailSuccess(value));
        } else {
          add(GetMyFavoritePostDetailFailed(value as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(InteractPostStatus.FavoriteFailed, null, null, null,
          ServerError.internalError());
    }
  }

  Stream<InteractPostState> _mapDeleteMyPostState(DeleteMyPost event) async* {
    final repository = InteractPostRepository();

    try {
      repository.deleteMyPost(event.id, (data) {
        if (data is int && (data == 200)) {
          add(const DeleteMyPostSuccess());
        } else {
          add(DeleteMyPostFailed(data as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(InteractPostStatus.DeleteFailed, null, null, null,
          ServerError.internalError());
    }
  }

  Stream<InteractPostState> _mapGetListPostCommentToState(
      ListPostComment event) async* {
    final repository = InteractPostRepository();

    try {
      repository.getListPostComment(event.postId, event.page, (value) {
        if (value is CommentResponse) {
          add(ListPostCommentSuccess(value));
        } else {
          add(ListPostCommentFailed(value as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(InteractPostStatus.ListCommentFailed, null, null,
          null, ServerError.internalError());
    }
  }

  Stream<InteractPostState> _mapCommentPostState(CommentPost event) async* {
    final repository = InteractPostRepository();
    final params = state.commentParameters;
    params["postId"] = event.postId;
    params["content"] = event.content;
    print(params);

    try {
      repository.commentPost(params, (data) {
        if (data is int && data == 200) {
          add(const CommentSuccess());
        } else {
          add(CommentFailed(data as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(InteractPostStatus.CommentFailed, null, null, null,
          ServerError.internalError());
    }
  }

  Stream<InteractPostState> _mapDeleteCommentPostState(
      DeleteCommentPost event) async* {
    final repository = InteractPostRepository();

    try {
      repository.deleteComment(event.postId, (data) {
        if (data is int && data == 200) {
          add(const DeleteCommentSuccess());
        } else {
          add(DeleteCommentFailed(data as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(InteractPostStatus.DeleteCommentFailed, null, null,
          null, ServerError.internalError());
    }
  }

  Stream<InteractPostState> _mapEditCommentPostState(
      EditCommentPost event) async* {
    final repository = InteractPostRepository();

    try {
      repository.editComment(event.content, event.commentId, (data) {
        if (data is int && data == 200 || data == 204) {
          add(const EditCommentSuccess());
        } else {
          add(EditCommentFailed(data as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(InteractPostStatus.EditCommentFailed, null, null,
          null, ServerError.internalError());
    }
  }

  Stream<InteractPostState> _mapReactPostState(ReactPost event) async* {
    final repository = InteractPostRepository();

    try {
      repository.reactPost(event.postId, (data) {
        if (data is int && data == 200 || data == 204) {
          add(ReactPostSuccess(data));
        } else {
          add(ReactPostFailed(data as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(InteractPostStatus.ReactPostFailed, null, null, null,
          ServerError.internalError());
    }
  }

  Stream<InteractPostState> _mapUnReactPostState(UnReactPost event) async* {
    final repository = InteractPostRepository();

    try {
      repository.unReactPost(event.postId, (data) {
        if (data is int && data == 200 || data == 204) {
          add(UnReactPostSuccess(data));
        } else {
          add(UnReactPostFailed(data as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(InteractPostStatus.UnReactPostFailed, null, null,
          null, ServerError.internalError());
    }
  }

  Stream<InteractPostState> _mapReportPostState(ReportPost event) async* {
    final repository = InteractPostRepository();
    final params = state.reportParameters;
    params["postId"] = event.postId;
    params["title"] = event.title;
    params["content"] = event.content;
    print(params);

    try {
      repository.reportPost(params, (data) {
        if (data is int && data == 200 || data == 204) {
          add(const ReportPostSuccess());
        } else {
          add(ReportPostFailed(data as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(InteractPostStatus.ReportPostFailed, null, null,
          null, ServerError.internalError());
    }
  }
}
