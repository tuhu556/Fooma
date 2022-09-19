class Endpoint {
  static final shared = Endpoint._internal();

  factory Endpoint() {
    return shared;
  }

  Endpoint._internal();

  final url = "api.fooma.tech:8443";
}

class Path {
  static final shared = Path._internal();

  factory Path() {
    return shared;
  }

  Path._internal();
  //Login
  final pathSignIn = '/api/auth/login';
  final pathSignInWithGoogle = '/api/auth/google-login';
  final pathRemoveDeviceId = '/api/user/delete-device';
  /*---------------------*/
  //Signup
  final pathSignUp = '/api/auth/register';
  final pathActiveCode = '/api/auth/active';
  final pathVerifyEmail = '/api/auth/forgot-pass-init';
  final pathReSendActive = '/api/auth/re-send-active';
  final pathVerifyCode = '/api/auth/forgot-pass-validate';
  final pathChangeNewPass = '/api/auth/forgot-pass-complete';
  /*---------------------*/
  //User profile
  final pathGetUserProfile = '/api/user/profile';
  final pathEditUserProfile = '/api/user/update-user';
  final pathChangePass = '/api/user/update-password';
  /*---------------------*/
  //Post
  final pathGetMyPost = '/api/post/mine';
  final pathGetAllPost = '/api/post';
  final pathCreatePost = '/api/post/create';
  final pathFavoritePost = '/api/favoritepost/mine';
  final pathSavePost = '/api/favoritepost/save';
  final pathUnSavePost = '/api/favoritepost/unsave';
  final pathEditMyPost = '/api/post/update';
  final pathDeleteMyPost = '/api/post/update-status';
  final pathListPostComment = '/api/postcomment';
  final pathReactPost = '/api/post-react';
  final pathReportPost = '/api/report/post';
  /*---------------------*/
  //Recipe-Post
  final pathRecipe = '/api/recipe';
  final pathRecipeOrigin = '/api/reciperelate/origin';
  final pathRecipeMeal = '/api/reciperelate/recipe-category';
  final pathRecipeProcess = '/api/reciperelate/method';
  final pathSaveRecipe = '/api/favoriterecipe/save';
  final pathUnSaveRecipe = '/api/favoriterecipe/unsave';
  final pathFavoriteRecipe = '/api/favoriterecipe/mine';
  final pathDeleteMyRecipe = '/api/recipe';
  final pathListRecipeComment = '/api/recipecomment';
  final pathReactRecipe = '/api/recipereact';
  final pathGetMyRecipe = '/api/recipe/mine';
  final pathReportRecipe = '/api/report/recipe';
  /*---------------------*/
  //Manage ingredient
  final pathIngredientUser = '/api/ingredient/mine';
  final pathIngredientDB = '/api/ingredientdb';
  final pathIngredientTotalUser = '/api/ingredient/total';
  final pathCreateIngredient = '/api/ingredient';
  final pathDeleteIngredient = '/api/ingredient/';
  final pathUpdateIngredient = '/api/ingredient/';
  final pathGetIngredientCategory = '/api/category/list';
  final pathIngredientSuggestionData = '/api/ingredientdb/mobile-app';
  final pathGetLocationIngredient = '/api/ingredientDB/location';
  /*---------------------*/
  //Recipe-App
  final pathRecipeSuggestionData = '/api/recipe/name';
  final pathGetAllRecipe = '/api/recipe';
  final pathGetRecipeDetailApp = '/api/recipe/';
  final pathGetRecipeSuggestion = "/api/recipe/suggest";
  final pathSaveRecipeApp = '/api/favoriterecipe/save';
  final pathUnSaveRecipeApp = '/api/favoriterecipe/unsave';
  final pathGetSavedRecipeApp = '/api/favoriterecipe/mine';
  final pathGetCategoryRecipe = '/api/reciperelate/recipe-category';
  final pathGetOriginRecipe = '/api/reciperelate/origin';
  final pathGetMethodRecipe = '/api/reciperelate/method';
  final pathRatingRecipe = '/api/recipecomment/rating';
  /*---------------------*/
  //Plan
  final pathGetPlan = '/api/plan';
  final pathCreatePlan = '/api/plan';
  final pathDeletePlan = '/api/plan/';
  final pathUpdatePlan = '/api/plan/';
  final pathGetPlanIngredient = '/api/plan/ingre';
  final pathGetSavedPlan = '/api/plan/saved';
  final pathSavePlan = '/api/plan/saved';
  final pathDeleteSavedPlan = '/api/plan/saved/';
  final pathUpdateSavedPlan = '/api/plan/saved/';

  /*---------------------*/
  final pathGetOthersUserProfile = '/api/user';
  final pathGetOthersPost = '/api/post/by-userid';
  final pathGetOthersRecipe = '/api/recipe/by-userid';

  /*---------------------*/
  //Notification
  final pathGetAllNoti = '/api/noti';

  /*---------------------*/

}
