part of 'others_user_profile_bloc.dart';

@immutable
class OthersUserProfileEvent extends Equatable {
  const OthersUserProfileEvent();

  @override
  List<Object> get props => [];
}

class OthersUserProfile extends OthersUserProfileEvent {
  final String userId;
  const OthersUserProfile(this.userId);
}

class GetOthersUserProfileDetailSuccess extends OthersUserProfileEvent {
  final UserProfileResponse othersProfile;
  const GetOthersUserProfileDetailSuccess(this.othersProfile);
}

class GetOthersUserProfileDetailFailed extends OthersUserProfileEvent {
  final ServerError error;
  const GetOthersUserProfileDetailFailed(this.error);
}

class OthersListPost extends OthersUserProfileEvent {
  final String userId;
  final int page;
  final int status;

  const OthersListPost(this.userId, this.page, this.status);
}

class GetOthersPostSuccess extends OthersUserProfileEvent {
  final MyPostResponse othersPost;
  const GetOthersPostSuccess(this.othersPost);
}

class GetOthersPostFailed extends OthersUserProfileEvent {
  final ServerError error;
  const GetOthersPostFailed(this.error);
}

class OthersListRecipe extends OthersUserProfileEvent {
  final String userId;
  final int page;
  final int status;

  const OthersListRecipe(this.userId, this.page, this.status);
}

class GetOthersRecipeSuccess extends OthersUserProfileEvent {
  final RecipeResponse othersRecipe;
  const GetOthersRecipeSuccess(this.othersRecipe);
}

class GetOthersRecipeFailed extends OthersUserProfileEvent {
  final ServerError error;
  const GetOthersRecipeFailed(this.error);
}
