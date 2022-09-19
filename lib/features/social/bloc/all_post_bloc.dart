import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';

import 'package:flutter/material.dart';
import 'package:foodhub/features/social/repository/all_post_repository.dart';
import 'package:foodhub/features/user_profile/model/my_post_entity.dart';

import '../../../service/networking.dart';
part 'all_post_event.dart';

part 'all_post_state.dart';

class AllPostBloc extends Bloc<AllPostEvent, AllPostState> {
  AllPostBloc() : super(AllPostState(status: AllPostStatus.Initial));

  @override
  Stream<AllPostState> mapEventToState(
    AllPostEvent event,
  ) async* {
    if (event is AllPost) {
      yield state.copyWith(AllPostStatus.Processing, null, null);
      yield* _mapGetMyPostToState(event);
    } else if (event is GetAllPostSuccess) {
      yield state.copyWith(AllPostStatus.Success, event.myPost, null);
    } else if (event is GetAllPostFailed) {
      yield state.copyWith(AllPostStatus.Failed, null, event.error);
    }
  }

  Stream<AllPostState> _mapGetMyPostToState(AllPost event) async* {
    final repository = AllPostRestRepository();

    try {
      repository.getAllPost(event.page, (value) {
        if (value is MyPostResponse) {
          add(GetAllPostSuccess(value));
        } else {
          add(GetAllPostFailed(value as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(
          AllPostStatus.Failed, null, ServerError.internalError());
    }
  }
}
