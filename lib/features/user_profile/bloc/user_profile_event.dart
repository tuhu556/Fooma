part of 'user_profile_bloc.dart';

@immutable
class UserProfileEvent extends Equatable {
  const UserProfileEvent();

  @override
  List<Object> get props => [];
}

class UserProfile extends UserProfileEvent {
  const UserProfile();
}

class GetUserProfileDetailSuccess extends UserProfileEvent {
  final UserProfileResponse data;
  const GetUserProfileDetailSuccess(this.data);
}

class GetUserProfileDetailBan extends UserProfileEvent {
  const GetUserProfileDetailBan();
}

class GetUserProfileDetailFailed extends UserProfileEvent {
  final ServerError error;
  const GetUserProfileDetailFailed(this.error);
}

class MyListPost extends UserProfileEvent {
  final int page;
  final int status;

  const MyListPost(this.page, this.status);
}

class GetMyPostSuccess extends UserProfileEvent {
  final MyPostResponse myPost;
  const GetMyPostSuccess(this.myPost);
}

class GetMyPostFailed extends UserProfileEvent {
  final ServerError error;
  const GetMyPostFailed(this.error);
}

class MyListPostPending extends UserProfileEvent {
  final int page;
  final int status;
  const MyListPostPending(this.page, this.status);
}

class GetMyPostPendingSuccess extends UserProfileEvent {
  final MyPostResponse myPostPending;
  const GetMyPostPendingSuccess(this.myPostPending);
}

class GetMyPostPendingFailed extends UserProfileEvent {
  final ServerError error;
  const GetMyPostPendingFailed(this.error);
}

class MyListPostDenied extends UserProfileEvent {
  final int page;
  final int status;
  const MyListPostDenied(this.page, this.status);
}

class GetMyPostDeniedSuccess extends UserProfileEvent {
  final MyPostResponse myPostDenied;
  const GetMyPostDeniedSuccess(this.myPostDenied);
}

class GetMyPostDeniedFailed extends UserProfileEvent {
  final ServerError error;
  const GetMyPostDeniedFailed(this.error);
}

class MyListRecipe extends UserProfileEvent {
  final int page;
  final int status;

  const MyListRecipe(this.page, this.status);
}

class GetMyRecipeSuccess extends UserProfileEvent {
  final RecipeResponse myRecipe;
  const GetMyRecipeSuccess(this.myRecipe);
}

class GetMyRecipeFailed extends UserProfileEvent {
  final ServerError error;
  const GetMyRecipeFailed(this.error);
}

class MyListRecipePending extends UserProfileEvent {
  final int page;
  final int status;
  const MyListRecipePending(this.page, this.status);
}

class GetMyRecipePendingSuccess extends UserProfileEvent {
  final RecipeResponse myRecipePending;
  const GetMyRecipePendingSuccess(this.myRecipePending);
}

class GetMyRecipePendingFailed extends UserProfileEvent {
  final ServerError error;
  const GetMyRecipePendingFailed(this.error);
}

class MyListRecipeDenied extends UserProfileEvent {
  final int page;
  final int status;
  const MyListRecipeDenied(this.page, this.status);
}

class GetMyRecipeDeniedSuccess extends UserProfileEvent {
  final RecipeResponse myRecipeDenied;
  const GetMyRecipeDeniedSuccess(this.myRecipeDenied);
}

class GetMyRecipeDeniedFailed extends UserProfileEvent {
  final ServerError error;
  const GetMyRecipeDeniedFailed(this.error);
}
