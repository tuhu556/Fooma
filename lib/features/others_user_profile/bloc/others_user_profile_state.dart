part of 'others_user_profile_bloc.dart';

@immutable
class OthersUserProfileState extends Equatable {
  final OthersUserProfileStatus status;

  UserProfileResponse? othersUserProfile;

  MyPostResponse? othersPost;
  RecipeResponse? othersRecipe;
  ServerError? error;

  OthersUserProfileState({required this.status});

  List<Object> get props => [status];

  OthersUserProfileState copyWith(
      OthersUserProfileStatus? status,
      UserProfileResponse? othersUserProfile,
      MyPostResponse? othersPost,
      RecipeResponse? othersRecipe,
      ServerError? error) {
    var newState = OthersUserProfileState(status: status ?? this.status);

    if (othersUserProfile != null) {
      newState.othersUserProfile = othersUserProfile;
    }
    if (othersPost != null) {
      newState.othersPost = othersPost;
    }

    if (othersRecipe != null) {
      newState.othersRecipe = othersRecipe;
    }

    if (error != null) {
      newState.error = error;
    }

    return newState;
  }
}

enum OthersUserProfileStatus {
  Initial,
  Processing,
  Success,
  Failed,
  MyPostInitial,
  MyPostProcessing,
  MyPostSuccess,
  MyPostFailed,
  MyRecipeInitial,
  MyRecipeProcessing,
  MyRecipeSuccess,
  MyRecipeFailed,
}
