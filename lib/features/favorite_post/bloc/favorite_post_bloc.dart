import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';

import 'package:flutter/material.dart';
import 'package:foodhub/features/user_profile/model/my_post_entity.dart';

import '../../../service/networking.dart';
import '../models/favorite_post_entity.dart';
import '../repository/favorite_post_repository.dart';
part 'favorite_post_event.dart';
part 'favorite_post_state.dart';

class MyFavoritePostBloc
    extends Bloc<MyFavoritePostEvent, MyFavoritePostState> {
  MyFavoritePostBloc()
      : super(MyFavoritePostState(status: MyFavoritePostStatus.Initial));

  @override
  Stream<MyFavoritePostState> mapEventToState(
    MyFavoritePostEvent event,
  ) async* {
    if (event is MyFavoritePost) {
      yield state.copyWith(MyFavoritePostStatus.Processing, null, null, null);
      yield* _mapGetMyFavoritePostToState(event);
    } else if (event is GetMyFavoritePostDetailSuccess) {
      yield state.copyWith(
          MyFavoritePostStatus.Success, event.data, null, null);
    } else if (event is GetMyFavoritePostDetailFailed) {
      yield state.copyWith(
          MyFavoritePostStatus.Failed, null, null, event.error);
    } else if (event is SavePost) {
      yield state.copyWith(
          MyFavoritePostStatus.SaveProcessing, null, null, null);
      yield* _mapSavePostToState(event);
    } else if (event is SavePostSuccess) {
      yield state.copyWith(MyFavoritePostStatus.SaveSuccess, null, null, null);
    } else if (event is SavePostFailed) {
      yield state.copyWith(
          MyFavoritePostStatus.SaveFailed, null, null, event.error);
    } else if (event is UnSavePost) {
      yield state.copyWith(
          MyFavoritePostStatus.UnSaveProcessing, null, null, null);
      yield* _mapUnSavePostToState(event);
    } else if (event is UnSavePostSuccess) {
      yield state.copyWith(
          MyFavoritePostStatus.UnSaveSuccess, null, null, null);
    } else if (event is UnSavePostFailed) {
      yield state.copyWith(
          MyFavoritePostStatus.UnSaveFailed, null, null, event.error);
    } else if (event is GetPostDetail) {
      yield state.copyWith(
          MyFavoritePostStatus.PostDetailProcessing, null, null, null);
      yield* _mapGetPostDetailToState(event);
    } else if (event is GetPostDetailSuccess) {
      yield state.copyWith(
          MyFavoritePostStatus.PostDetailSuccess, null, event.data, null);
    } else if (event is GetPostDetailFailed) {
      yield state.copyWith(
          MyFavoritePostStatus.PostDetailFailed, null, null, event.error);
    }
  }

  Stream<MyFavoritePostState> _mapGetMyFavoritePostToState(
      MyFavoritePost event) async* {
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
      yield state.copyWith(
          MyFavoritePostStatus.Failed, null, null, ServerError.internalError());
    }
  }

  Stream<MyFavoritePostState> _mapGetPostDetailToState(
      GetPostDetail event) async* {
    final repository = MyFavoritePostRestRepository();

    try {
      repository.getPostById(event.postId, (value) {
        if (value is MyPost) {
          add(GetPostDetailSuccess(value));
        } else {
          add(GetPostDetailFailed(value as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(MyFavoritePostStatus.PostDetailFailed, null, null,
          ServerError.internalError());
    }
  }

  Stream<MyFavoritePostState> _mapSavePostToState(SavePost event) async* {
    final repository = MyFavoritePostRestRepository();

    try {
      repository.savePost(event.postId, (data) {
        if (data is int && (data == 200) || data == 204) {
          add(const SavePostSuccess());
        } else {
          add(SavePostFailed(data as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(MyFavoritePostStatus.SaveFailed, null, null,
          ServerError.internalError());
    }
  }

  Stream<MyFavoritePostState> _mapUnSavePostToState(UnSavePost event) async* {
    final repository = MyFavoritePostRestRepository();

    try {
      repository.unSavePost(event.postId, (data) {
        if (data is int && (data == 200) || data == 204) {
          add(const UnSavePostSuccess());
        } else {
          add(UnSavePostFailed(data as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(MyFavoritePostStatus.UnSaveFailed, null, null,
          ServerError.internalError());
    }
  }
}
