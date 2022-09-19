part of 'interact_recipe_bloc.dart';

@immutable
class InteractRecipeState extends Equatable {
  final InteractRecipeStatus status;
  ServerError? error;

  CommentResponse? commentRecipe;
  Map<String, dynamic> commentParameters = {};
  MethodRecipeResponse? methodRecipe;
  RecipeResponse? myFavoriteRecipe;
  Map<String, dynamic> reportParameters = {};
  int? code;
  Map<String, dynamic> ratingParameters = {};
  InteractRecipeState({required this.status});

  List<Object> get props => [status];

  InteractRecipeState copyWith(
      InteractRecipeStatus? status,
      CommentResponse? commentResponse,
      MethodRecipeResponse? methodRecipe,
      RecipeResponse? myFavoriteRecipe,
      int? code,
      ServerError? error) {
    var newState = InteractRecipeState(status: status ?? this.status);
    if (myFavoriteRecipe != null) {
      newState.myFavoriteRecipe = myFavoriteRecipe;
    }
    if (commentResponse != null) {
      newState.commentRecipe = commentResponse;
    }
    if (methodRecipe != null) {
      newState.methodRecipe = methodRecipe;
    }

    if (code != null) {
      newState.code = code;
    }
    newState.commentParameters = commentParameters;
    newState.reportParameters = reportParameters;
    newState.ratingParameters = ratingParameters;
    if (error != null) {
      newState.error = error;
    }

    return newState;
  }
}

enum InteractRecipeStatus {
  SaveInitial,
  SaveProcessing,
  SaveSuccess,
  SaveFailed,
  UnSaveInitial,
  UnSaveProcessing,
  UnSaveSuccess,
  UnSaveFailed,
  FavoriteInitial,
  FavoriteProcessing,
  FavoriteSuccess,
  FavoriteFailed,
  DeleteInitial,
  DeleteProcessing,
  DeleteSuccess,
  DeleteFailed,
  ListCommentInitial,
  ListCommentProcessing,
  ListCommentSuccess,
  ListCommentFailed,
  CommentInitial,
  CommentProcessing,
  CommentSuccess,
  CommentFailed,
  DeleteCommentInitial,
  DeleteCommentProcessing,
  DeleteCommentSuccess,
  DeleteCommentFailed,
  EditCommentInitial,
  EditCommentProcessing,
  EditCommentSuccess,
  EditCommentFailed,
  ReactRecipeInitial,
  ReactRecipeProcessing,
  ReactRecipeSuccess,
  ReactRecipeFailed,
  UnReactRecipeInitial,
  UnReactRecipeProcessing,
  UnReactRecipeSuccess,
  UnReactRecipeFailed,
  MethodRecipeInitial,
  MethodRecipeProcessing,
  MethodRecipeSuccess,
  MethodRecipeFailed,
  ReportRecipeInitial,
  ReportRecipeProcessing,
  ReportRecipeSuccess,
  ReportRecipeFailed,
  RatingRecipeInitial,
  RatingRecipeProcessing,
  RatingRecipeSuccess,
  RatingRecipeFailed,
}
