part of 'interact_recipe_bloc.dart';

@immutable
class InteractRecipeEvent extends Equatable {
  const InteractRecipeEvent();

  @override
  List<Object> get props => [];
}

class SaveRecipeSocial extends InteractRecipeEvent {
  String recipeId;
  SaveRecipeSocial(this.recipeId);
}

class SaveRecipeSocialSuccess extends InteractRecipeEvent {
  final int code;
  const SaveRecipeSocialSuccess(this.code);
}

class SaveRecipeSocialFailed extends InteractRecipeEvent {
  final ServerError error;
  const SaveRecipeSocialFailed(this.error);
}

class UnSaveRecipeSocial extends InteractRecipeEvent {
  String recipeId;
  UnSaveRecipeSocial(this.recipeId);
}

class UnSaveRecipeSocialSuccess extends InteractRecipeEvent {
  final int code;
  const UnSaveRecipeSocialSuccess(this.code);
}

class UnSaveRecipeSocialFailed extends InteractRecipeEvent {
  final ServerError error;
  const UnSaveRecipeSocialFailed(this.error);
}

class MyFavoriteSocialRecipe extends InteractRecipeEvent {
  const MyFavoriteSocialRecipe();
}

class GetMyFavoriteRecipeDetailSuccess extends InteractRecipeEvent {
  final RecipeResponse data;
  const GetMyFavoriteRecipeDetailSuccess(this.data);
}

class GetMyFavoriteRecipeDetailFailed extends InteractRecipeEvent {
  final ServerError error;
  const GetMyFavoriteRecipeDetailFailed(this.error);
}

class DeleteMyRecipe extends InteractRecipeEvent {
  final String id;

  const DeleteMyRecipe({
    required this.id,
  });
}

class DeleteMyRecipeSuccess extends InteractRecipeEvent {
  const DeleteMyRecipeSuccess();
}

class DeleteMyRecipeFailed extends InteractRecipeEvent {
  final ServerError error;
  const DeleteMyRecipeFailed(this.error);
}

class ListRecipeComment extends InteractRecipeEvent {
  final String RecipeId;
  final int page;
  const ListRecipeComment(this.RecipeId, this.page);
}

class ListRecipeCommentSuccess extends InteractRecipeEvent {
  final CommentResponse comment;
  const ListRecipeCommentSuccess(this.comment);
}

class ListRecipeCommentFailed extends InteractRecipeEvent {
  final ServerError error;
  const ListRecipeCommentFailed(this.error);
}

class CommentRecipe extends InteractRecipeEvent {
  final String recipeId;
  final String content;
  const CommentRecipe(this.recipeId, this.content);
}

class CommentSuccess extends InteractRecipeEvent {
  const CommentSuccess();
}

class CommentFailed extends InteractRecipeEvent {
  final ServerError error;
  const CommentFailed(this.error);
}

class DeleteCommentRecipe extends InteractRecipeEvent {
  final String recipeId;
  const DeleteCommentRecipe(this.recipeId);
}

class DeleteCommentSuccess extends InteractRecipeEvent {
  const DeleteCommentSuccess();
}

class DeleteCommentFailed extends InteractRecipeEvent {
  final ServerError error;
  const DeleteCommentFailed(this.error);
}

class EditCommentRecipe extends InteractRecipeEvent {
  final String commentId;
  final String content;
  const EditCommentRecipe(this.commentId, this.content);
}

class EditCommentSuccess extends InteractRecipeEvent {
  const EditCommentSuccess();
}

class EditCommentFailed extends InteractRecipeEvent {
  final ServerError error;
  const EditCommentFailed(this.error);
}

class ReactRecipe extends InteractRecipeEvent {
  final String recipeId;
  const ReactRecipe(this.recipeId);
}

class ReactRecipeSuccess extends InteractRecipeEvent {
  final int code;
  const ReactRecipeSuccess(this.code);
}

class ReactRecipeFailed extends InteractRecipeEvent {
  final ServerError error;
  const ReactRecipeFailed(this.error);
}

class UnReactRecipe extends InteractRecipeEvent {
  final String recipeId;
  const UnReactRecipe(this.recipeId);
}

class UnReactRecipeSuccess extends InteractRecipeEvent {
  final int code;
  const UnReactRecipeSuccess(this.code);
}

class UnReactRecipeFailed extends InteractRecipeEvent {
  final ServerError error;
  const UnReactRecipeFailed(this.error);
}

class GetMethodRecipe extends InteractRecipeEvent {
  final String recipeId;
  const GetMethodRecipe(this.recipeId);
}

class GetMethodRecipeSuccess extends InteractRecipeEvent {
  final MethodRecipeResponse methodRecipe;
  const GetMethodRecipeSuccess(this.methodRecipe);
}

class GetMethodRecipeFailed extends InteractRecipeEvent {
  final ServerError error;
  const GetMethodRecipeFailed(this.error);
}

class ReportRecipe extends InteractRecipeEvent {
  final String recipeId;
  final String title;
  final String content;
  const ReportRecipe(this.recipeId, this.title, this.content);
}

class ReportRecipeSuccess extends InteractRecipeEvent {
  const ReportRecipeSuccess();
}

class ReportRecipeFailed extends InteractRecipeEvent {
  final ServerError error;
  const ReportRecipeFailed(this.error);
}

class RatingRecipe extends InteractRecipeEvent {
  final String recipeId;
  final int rating;
  final String comment;
  const RatingRecipe(this.recipeId, this.rating, this.comment);
}

class RatingRecipeSuccess extends InteractRecipeEvent {
  const RatingRecipeSuccess();
}

class RatingRecipeFailed extends InteractRecipeEvent {
  final ServerError error;
  const RatingRecipeFailed(this.error);
}
