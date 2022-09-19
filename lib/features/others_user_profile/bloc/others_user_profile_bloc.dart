import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';

import 'package:flutter/material.dart';
import 'package:foodhub/features/others_user_profile/repository/others_user_profile_repository.dart';

import '../../../service/networking.dart';
import '../../social/models/recipe_entity.dart';
import '../../user_profile/model/my_post_entity.dart';
import '../../user_profile/model/user_profile_entity.dart';
import '../../user_profile/repository/user_profile_repository.dart';
part 'others_user_profile_event.dart';

part 'others_user_profile_state.dart';

class OthersUserProfileBloc
    extends Bloc<OthersUserProfileEvent, OthersUserProfileState> {
  OthersUserProfileBloc()
      : super(OthersUserProfileState(status: OthersUserProfileStatus.Initial));

  @override
  Stream<OthersUserProfileState> mapEventToState(
    OthersUserProfileEvent event,
  ) async* {
    if (event is OthersUserProfile) {
      yield state.copyWith(
          OthersUserProfileStatus.Processing, null, null, null, null);
      yield* _mapGetOthersUserPageDetailToState(event);
    } else if (event is GetOthersUserProfileDetailSuccess) {
      yield state.copyWith(OthersUserProfileStatus.Success, event.othersProfile,
          null, null, null);
    } else if (event is GetOthersUserProfileDetailFailed) {
      yield state.copyWith(
          OthersUserProfileStatus.Failed, null, null, null, event.error);
    }
    //!
    else if (event is OthersListPost) {
      yield state.copyWith(
          OthersUserProfileStatus.MyPostProcessing, null, null, null, null);
      yield* _mapGetOthersPostToState(event);
    } else if (event is GetOthersPostSuccess) {
      yield state.copyWith(OthersUserProfileStatus.MyPostSuccess, null,
          event.othersPost, null, null);
    } else if (event is GetOthersPostFailed) {
      yield state.copyWith(
          OthersUserProfileStatus.MyPostFailed, null, null, null, event.error);
    }

    //!
    else if (event is OthersListRecipe) {
      yield state.copyWith(
          OthersUserProfileStatus.MyRecipeProcessing, null, null, null, null);
      yield* _mapGetOthersRecipeToState(event);
    } else if (event is GetOthersRecipeSuccess) {
      yield state.copyWith(OthersUserProfileStatus.MyRecipeSuccess, null, null,
          event.othersRecipe, null);
    } else if (event is GetOthersRecipeFailed) {
      yield state.copyWith(OthersUserProfileStatus.MyRecipeFailed, null, null,
          null, event.error);
    }
  }

  Stream<OthersUserProfileState> _mapGetOthersUserPageDetailToState(
      OthersUserProfile event) async* {
    final repository = OthersUserProfileRestRepository();

    try {
      repository.getOthersUserProfile(event.userId, (value) {
        if (value is UserProfileResponse) {
          add(GetOthersUserProfileDetailSuccess(value));
        } else {
          add(GetOthersUserProfileDetailFailed(value as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(OthersUserProfileStatus.Failed, null, null, null,
          ServerError.internalError());
    }
  }

  Stream<OthersUserProfileState> _mapGetOthersPostToState(
      OthersListPost event) async* {
    final repository = OthersUserProfileRestRepository();

    try {
      repository.getOthersPost(event.page, event.status, event.userId, (value) {
        if (value is MyPostResponse) {
          add(GetOthersPostSuccess(value));
        } else {
          add(GetOthersPostFailed(value as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(OthersUserProfileStatus.MyPostFailed, null, null,
          null, ServerError.internalError());
    }
  }

  Stream<OthersUserProfileState> _mapGetOthersRecipeToState(
      OthersListRecipe event) async* {
    final repository = OthersUserProfileRestRepository();

    try {
      repository.getOthersRecipe(event.page, event.status, event.userId,
          (value) {
        if (value is RecipeResponse) {
          add(GetOthersRecipeSuccess(value));
        } else {
          add(GetOthersRecipeFailed(value as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(OthersUserProfileStatus.MyRecipeFailed, null, null,
          null, ServerError.internalError());
    }
  }
}
