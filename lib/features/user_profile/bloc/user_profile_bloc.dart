import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';

import 'package:flutter/material.dart';
import 'package:foodhub/features/social/models/recipe_entity.dart';

import '../../../service/networking.dart';
import '../model/my_post_entity.dart';
import '../model/user_profile_entity.dart';
import '../repository/user_profile_repository.dart';
part 'user_profile_event.dart';

part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  UserProfileBloc()
      : super(UserProfileState(status: UserProfileStatus.Initial));

  @override
  Stream<UserProfileState> mapEventToState(
    UserProfileEvent event,
  ) async* {
    if (event is UserProfile) {
      yield state.copyWith(UserProfileStatus.Processing, null, null, null, null,
          null, null, null, null);
      yield* _mapGetUserPageDetailToState(event);
    } else if (event is GetUserProfileDetailSuccess) {
      yield state.copyWith(UserProfileStatus.Success, event.data, null, null,
          null, null, null, null, null);
    } else if (event is GetUserProfileDetailBan) {
      yield state.copyWith(UserProfileStatus.Ban, null, null, null, null, null,
          null, null, null);
    } else if (event is GetUserProfileDetailFailed) {
      yield state.copyWith(UserProfileStatus.Failed, null, null, null, null,
          null, null, null, event.error);
    }
    //!
    else if (event is MyListPost) {
      yield state.copyWith(UserProfileStatus.MyPostProcessing, null, null, null,
          null, null, null, null, null);
      yield* _mapGetMyPostToState(event);
    } else if (event is GetMyPostSuccess) {
      yield state.copyWith(UserProfileStatus.MyPostSuccess, null, event.myPost,
          null, null, null, null, null, null);
    } else if (event is GetMyPostFailed) {
      yield state.copyWith(UserProfileStatus.MyPostFailed, null, null, null,
          null, null, null, null, event.error);
    }
    //!
    else if (event is MyListPostPending) {
      yield state.copyWith(UserProfileStatus.MyPostPendingProcessing, null,
          null, null, null, null, null, null, null);
      yield* _mapGetMyPostPendingToState(event);
    } else if (event is GetMyPostPendingSuccess) {
      yield state.copyWith(UserProfileStatus.MyPostPendingSuccess, null, null,
          event.myPostPending, null, null, null, null, null);
    } else if (event is GetMyPostPendingFailed) {
      yield state.copyWith(UserProfileStatus.MyPostPendingFailed, null, null,
          null, null, null, null, null, event.error);
    }
    //!
    else if (event is MyListPostDenied) {
      yield state.copyWith(UserProfileStatus.MyPostDeniedProcessing, null, null,
          null, null, null, null, null, null);
      yield* _mapGetMyPostDeniedToState(event);
    } else if (event is GetMyPostDeniedSuccess) {
      yield state.copyWith(UserProfileStatus.MyPostDeniedSuccess, null, null,
          null, event.myPostDenied, null, null, null, null);
    } else if (event is GetMyPostDeniedFailed) {
      yield state.copyWith(UserProfileStatus.MyPostDeniedFailed, null, null,
          null, null, null, null, null, event.error);
    }
    //!
    else if (event is MyListRecipe) {
      yield state.copyWith(UserProfileStatus.MyRecipeProcessing, null, null,
          null, null, null, null, null, null);
      yield* _mapGetMyRecipeToState(event);
    } else if (event is GetMyRecipeSuccess) {
      yield state.copyWith(UserProfileStatus.MyRecipeSuccess, null, null, null,
          null, event.myRecipe, null, null, null);
    } else if (event is GetMyRecipeFailed) {
      yield state.copyWith(UserProfileStatus.MyRecipeFailed, null, null, null,
          null, null, null, null, event.error);
    }
    //!
    else if (event is MyListRecipePending) {
      yield state.copyWith(UserProfileStatus.MyRecipePendingProcessing, null,
          null, null, null, null, null, null, null);
      yield* _mapGetMyRecipePendingToState(event);
    } else if (event is GetMyRecipePendingSuccess) {
      yield state.copyWith(UserProfileStatus.MyRecipePendingSuccess, null, null,
          null, null, null, event.myRecipePending, null, null);
    } else if (event is GetMyRecipePendingFailed) {
      yield state.copyWith(UserProfileStatus.MyRecipePendingFailed, null, null,
          null, null, null, null, null, event.error);
    }
    //!
    else if (event is MyListRecipeDenied) {
      yield state.copyWith(UserProfileStatus.MyRecipeDeniedProcessing, null,
          null, null, null, null, null, null, null);
      yield* _mapGetMyRecipeDeniedToState(event);
    } else if (event is GetMyRecipeDeniedSuccess) {
      yield state.copyWith(UserProfileStatus.MyRecipeDeniedSuccess, null, null,
          null, null, null, null, event.myRecipeDenied, null);
    } else if (event is GetMyRecipeDeniedFailed) {
      yield state.copyWith(UserProfileStatus.MyRecipeDeniedFailed, null, null,
          null, null, null, null, null, event.error);
    }
  }

  Stream<UserProfileState> _mapGetUserPageDetailToState(
      UserProfile event) async* {
    final repository = UserProfileRestRepository();

    try {
      repository.getUserProfile((value) {
        if (value is UserProfileResponse) {
          add(GetUserProfileDetailSuccess(value));
        } else if (value is int && (value == 1412)) {
          add(const GetUserProfileDetailBan());
        } else {
          add(GetUserProfileDetailFailed(value as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(UserProfileStatus.Failed, null, null, null, null,
          null, null, null, ServerError.internalError());
    }
  }

  Stream<UserProfileState> _mapGetMyPostToState(MyListPost event) async* {
    final repository = MyPostRestRepository();

    try {
      repository.getMyPost(event.page, event.status, (value) {
        if (value is MyPostResponse) {
          add(GetMyPostSuccess(value));
        } else {
          add(GetMyPostFailed(value as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(UserProfileStatus.MyPostFailed, null, null, null,
          null, null, null, null, ServerError.internalError());
    }
  }

  Stream<UserProfileState> _mapGetMyPostPendingToState(
      MyListPostPending event) async* {
    final repository = MyPostRestRepository();

    try {
      repository.getMyPostPending(event.page, event.status, (value) {
        if (value is MyPostResponse) {
          add(GetMyPostPendingSuccess(value));
        } else {
          add(GetMyPostPendingFailed(value as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(UserProfileStatus.MyPostPendingFailed, null, null,
          null, null, null, null, null, ServerError.internalError());
    }
  }

  Stream<UserProfileState> _mapGetMyPostDeniedToState(
      MyListPostDenied event) async* {
    final repository = MyPostRestRepository();

    try {
      repository.getMyPostDenied(event.page, event.status, (value) {
        if (value is MyPostResponse) {
          add(GetMyPostDeniedSuccess(value));
        } else {
          add(GetMyPostDeniedFailed(value as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(UserProfileStatus.MyPostDeniedFailed, null, null,
          null, null, null, null, null, ServerError.internalError());
    }
  }

  Stream<UserProfileState> _mapGetMyRecipeToState(MyListRecipe event) async* {
    final repository = MyPostRestRepository();

    try {
      repository.getMyRecipe(event.page, event.status, (value) {
        if (value is RecipeResponse) {
          add(GetMyRecipeSuccess(value));
        } else {
          add(GetMyRecipeFailed(value as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(UserProfileStatus.MyRecipeFailed, null, null, null,
          null, null, null, null, ServerError.internalError());
    }
  }

  Stream<UserProfileState> _mapGetMyRecipePendingToState(
      MyListRecipePending event) async* {
    final repository = MyPostRestRepository();

    try {
      repository.getMyRecipePending(event.page, event.status, (value) {
        if (value is RecipeResponse) {
          add(GetMyRecipePendingSuccess(value));
        } else {
          add(GetMyRecipePendingFailed(value as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(UserProfileStatus.MyRecipePendingFailed, null, null,
          null, null, null, null, null, ServerError.internalError());
    }
  }

  Stream<UserProfileState> _mapGetMyRecipeDeniedToState(
      MyListRecipeDenied event) async* {
    final repository = MyPostRestRepository();

    try {
      repository.getMyRecipeDenied(event.page, event.status, (value) {
        if (value is RecipeResponse) {
          add(GetMyRecipeDeniedSuccess(value));
        } else {
          add(GetMyRecipeDeniedFailed(value as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(UserProfileStatus.MyRecipeDeniedFailed, null, null,
          null, null, null, null, null, ServerError.internalError());
    }
  }
}
