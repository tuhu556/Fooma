import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/features/my_post/repository/my_post_repository.dart';
import 'package:foodhub/session/session.dart';

import '../../../service/networking.dart';
import '../model/my_post_entity.dart';

part 'my_post_event.dart';
part 'my_post_state.dart';

class EditMyPostBloc extends Bloc<EditMyPostEvent, EditMyPostState> {
  EditMyPostBloc() : super(EditMyPostState(status: EditMyPostStatus.Initial));

  @override
  Stream<EditMyPostState> mapEventToState(
    EditMyPostEvent event,
  ) async* {
    if (event is EditMyPost) {
      yield state.copyWith(EditMyPostStatus.Processing, null);
      yield* _mapEditMyPostState(event);
    } else if (event is EditMyPostSuccess) {
      yield state.copyWith(EditMyPostStatus.Success, null);
    } else if (event is EditMyPostFailed) {
      yield state.copyWith(EditMyPostStatus.Failed, event.error);
    }
  }

  Stream<EditMyPostState> _mapEditMyPostState(EditMyPost event) async* {
    final repository = EditPostRestRepository();
    final params = state.editMyPostParameters;
    params["id"] = event.id;
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
      repository.editMyPost(params, (data) {
        if (data is int && (data == 200)) {
          add(EditMyPostSuccess());
        } else {
          add(EditMyPostFailed(data as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(
          EditMyPostStatus.Failed, ServerError.internalError());
    }
  }
}
