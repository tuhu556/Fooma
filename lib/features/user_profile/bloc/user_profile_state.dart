part of 'user_profile_bloc.dart';

@immutable
class UserProfileState extends Equatable {
  final UserProfileStatus status;

  UserProfileResponse? userProfile;

  MyPostResponse? myPost;
  MyPostResponse? myPostPending;
  MyPostResponse? myPostDenied;
  RecipeResponse? myRecipe;
  RecipeResponse? myRecipePending;
  RecipeResponse? myRecipeDenied;
  ServerError? error;

  UserProfileState({required this.status});

  List<Object> get props => [status];

  UserProfileState copyWith(
      UserProfileStatus? status,
      UserProfileResponse? userProfile,
      MyPostResponse? myPost,
      MyPostResponse? myPostPending,
      MyPostResponse? myPostDenied,
      RecipeResponse? myRecipe,
      RecipeResponse? myRecipePending,
      RecipeResponse? myRecipeDenied,
      ServerError? error) {
    var newState = UserProfileState(status: status ?? this.status);

    if (userProfile != null) {
      newState.userProfile = userProfile;
    }
    if (myPost != null) {
      newState.myPost = myPost;
    }

    if (myPostPending != null) {
      newState.myPostPending = myPostPending;
    }
    if (myPostDenied != null) {
      newState.myPostDenied = myPostDenied;
    }

    if (myRecipe != null) {
      newState.myRecipe = myRecipe;
    }

    if (myRecipePending != null) {
      newState.myRecipePending = myRecipePending;
    }

    if (myRecipeDenied != null) {
      newState.myRecipeDenied = myRecipeDenied;
    }

    if (error != null) {
      newState.error = error;
    }

    return newState;
  }
}

enum UserProfileStatus {
  Initial,
  Processing,
  Success,
  Ban,
  Failed,
  MyPostInitial,
  MyPostProcessing,
  MyPostSuccess,
  MyPostFailed,
  MyPostPendingInitial,
  MyPostPendingProcessing,
  MyPostPendingSuccess,
  MyPostPendingFailed,
  MyPostDeniedInitial,
  MyPostDeniedProcessing,
  MyPostDeniedSuccess,
  MyPostDeniedFailed,
  MyRecipeInitial,
  MyRecipeProcessing,
  MyRecipeSuccess,
  MyRecipeFailed,
  MyRecipePendingInitial,
  MyRecipePendingProcessing,
  MyRecipePendingSuccess,
  MyRecipePendingFailed,
  MyRecipeDeniedInitial,
  MyRecipeDeniedProcessing,
  MyRecipeDeniedSuccess,
  MyRecipeDeniedFailed,
}
