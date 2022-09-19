import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/features/upload_post/models/upload_post_entity.dart';

import '../../../service/networking.dart';
import '../repository/upload_post_repository.dart';

part 'upload_post_event.dart';
part 'upload_post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(PostState(status: PostStatus.Initial));

  @override
  Stream<PostState> mapEventToState(
    PostEvent event,
  ) async* {
    if (event is CreatePostEvent) {
      yield state.copyWith(PostStatus.Processing, null);
      yield* _mapPostState(event);
    } else if (event is CreatePostSuccess) {
      yield state.copyWith(PostStatus.Success, null);
    } else if (event is CreatePostFailed) {
      yield state.copyWith(PostStatus.Failed, event.error);
    }
  }

  Stream<PostState> _mapPostState(CreatePostEvent event) async* {
    final repository = PostRestRepository();
    final params = state.createPostParameters;
    params["title"] = event.title;
    params["content"] = event.content;
    params["hashtag"] = event.hashtag;
    params["postImages"] = [
      for (int i = 0; i < event.postImages!.length; i++)
        {
          "orderNumber": event.postImages![i].orderNumber,
          "imageUrl": event.postImages![i].imageUrl,
          "isThumbnail": event.postImages![i].isThumbnail,
        }
    ];
    print(params);

    try {
      repository.createPost(params, (data) {
        if (data is int && (data == 200)) {
          add(const CreatePostSuccess());
        } else {
          add(CreatePostFailed(data as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(PostStatus.Failed, ServerError.internalError());
    }
  }
}
