import 'package:flutter/material.dart';
import 'package:foodhub/app.dart';
import 'package:foodhub/features/edit_user_profile/screens/edit_user_profile.dart';
import 'package:foodhub/features/favorite_post/screens/favorite_post.dart';

import 'package:foodhub/features/forgot_password/screens/change_forgot_pass.dart';
import 'package:foodhub/features/forgot_password/screens/code_form.dart';
import 'package:foodhub/features/forgot_password/screens/email_form.dart';
import 'package:foodhub/features/forgot_password/screens/pass_success_screen.dart';

import 'package:foodhub/features/home/screens/home.dart';

import 'package:foodhub/features/ingredient_detail/screens/ingredient_detail.dart';
import 'package:foodhub/features/ingredient_manager/screens/add_ingredient.dart';
import 'package:foodhub/features/ingredient_manager/screens/ingredient_manager.dart';
import 'package:foodhub/features/ingredient_manager/screens/ingredient_section.dart';
import 'package:foodhub/features/ingredient_manager/screens/recipe_suggestion.dart';
import 'package:foodhub/features/ingredient_manager/screens/update_ingredient.dart';
import 'package:foodhub/features/my_post/screens/edit_post.dart';
import 'package:foodhub/features/my_post/screens/my_post.dart';
import 'package:foodhub/features/my_post/screens/reup_post.dart';
import 'package:foodhub/features/my_recipe/screens/my_recipe.dart';
import 'package:foodhub/features/notification/screens/notification.dart';
import 'package:foodhub/features/others_user_profile/screens/others_user_profile.dart';
import 'package:foodhub/features/password_setting/bloc/change_password/change_password_bloc.dart';
import 'package:foodhub/features/password_setting/screen/change_password.dart';
import 'package:foodhub/features/plan/screens/calculateIngredient.dart';
import 'package:foodhub/features/plan/screens/ingredientPreparePlan.dart';
import 'package:foodhub/features/plan/screens/plan.dart';
import 'package:foodhub/features/plan/screens/recipePlanDetail.dart';
import 'package:foodhub/features/plan/screens/resultSearchRecipePlan.dart';
import 'package:foodhub/features/plan/screens/savedPlan.dart';
import 'package:foodhub/features/plan/screens/savedRecipeForPlan.dart';
import 'package:foodhub/features/plan/screens/searchRecipePlan.dart';
import 'package:foodhub/features/plan/screens/updatePlan.dart';
import 'package:foodhub/features/saved_recipe/screens/saved_recipe.dart';
import 'package:foodhub/features/question/screens/question.dart';
import 'package:foodhub/features/search_recipe/screens/result.dart';

import 'package:foodhub/features/settings/screens/setting.dart';

import 'package:foodhub/features/signin/screens/active_code.dart';

import 'package:foodhub/features/signin/screens/signin.dart';
import 'package:foodhub/features/signin/screens/signin_welcome.dart';
import 'package:foodhub/features/signup/screens/signup.dart';
import 'package:foodhub/features/signup/screens/success_screen.dart';
import 'package:foodhub/features/social/screens/view_post_screen.dart';
import 'package:foodhub/features/social/screens/view_recipe_screen.dart';
import 'package:foodhub/features/social/widgets/search_post.dart';
import 'package:foodhub/features/splash/screens/splash.dart';
import 'package:foodhub/features/upload_post/screens/upload_post.dart';
import 'package:foodhub/features/upload_recipe/screens/reup_recipe.dart';
import 'package:foodhub/features/upload_recipe/screens/upload_recipe.dart';
import 'package:foodhub/features/user_profile/screens/user_profile.dart';

import '../features/ingredient_manager/screens/ingredient_search.dart';
import '../features/recipe_detail_app/screens/recipe_detail.dart';
import '../features/search_recipe/screens/searchRecipe.dart';
import '../features/upload_recipe/screens/edit_recipe.dart';

class Routes {
  static const String mainTab = '/lib/app.dart';
  static const String signInWelcome =
      '/lib/features/signin/screens/signin_welcome.dart';
  static const String signIn = '/lib/features/signin/screens/signin.dart';
  static const String signUp = '/lib/features/signup/screens/signup.dart';
  static const String addFood =
      '/lib/features/ingredient_manager/screens/add_ingredient.dart';
  static const String splash = '/lib/features/splash/screens/splash.dart';
  static const String ingredientManager =
      'lib/features/ingredient_manager/screens/ingredient_manager.dart';
  static const String forgotPass =
      '/lib/features/forgot_password/screens/email_form.dart';

  static const String checkCode =
      'lib/features/forgot_password/screens/code_form.dart';
  static const String changeForgotPass =
      'lib/features/forgot_password/screens/change_forgot_pass.dart';
  static const String home = 'lib/features/home/screens/home.dart';

  static const String ingredientDetail =
      '/lib/features/ingredient_detail/screens/ingredient_detail.dart';
  static const String recipeDetail =
      '/lib/features/recipe_detail_app/screens/recipe_detail.dart';
  static const String uploadRecipe =
      '/lib/features/upload_recipe/screens/upload_recipe.dart';
  static const String userProfile =
      '/lib/features/user_profile/screens/user_profile.dart';
  static const String editUserProfile =
      '/lib/features/edit_user_profile/screens/edit_user_profile.dart';
  static const String uploadPost =
      '/lib/features/upload_post/screens/upload_post.dart';

  static const String detailPerson =
      '/lib/features/detail_person/screens/detail_person.dart';
  static const String setting = '/lib/features/settings/screens/setting.dart';
  static const String myRecipe =
      '/lib/features/my_recipe/screens/my_recipe.dart';
  static const String myPost = '/lib/features/my_post/screens/my_post.dart';
  static const String favoritePost =
      '/lib/features/favorite_post/screens/favorite_post.dart';
  static const String favoriteRecipe =
      '/lib/features/favorite_recipe/screens/favorite_recipe.dart';
  static const String searchRecipe =
      '/lib/features/search_recipe/screens/searchRecipe.dart';
  static const String question = '/lib/features/question/screens/question.dart';
  static const String recipeDetailUser =
      '/lib/features/social/screens/view_recipe_screen.dart';
  static const String postDetailUser =
      '/lib/features/social/screens/view_post_screen.dart';
  static const String searchFood =
      '/lib/features/ingredient_manager/screens/ingredient_search.dart';
  static const String searchPost =
      '/lib/features/social/widgets/search_post.dart';
  static const String editPost = '/lib/features/my_post/screens/edit_post.dart';
  static const String plan = '/lib/features/plan/screens/plant.dart';
  static const String signUpSuccess =
      '/lib/features/signup/screens/success_screen.dart';
  static const String activeCode =
      '/lib/features/signin/screens/active_code.dart';
  static const String changePassSuccess =
      '/lib/features/forgot_password/screens/pass_success_screen.dart';
  static const String reupPost = '/lib/features/my_post/screens/reup_post.dart';
  static const String editRecipe =
      '/lib/features/upload_recipe/screens/edit_recipe.dart';
  static const String editIngredient =
      '/lib/features/ingredient_manager/screens/update_ingredient.dart';
  static const String reupRecipe =
      '/lib/features/upload_recipe/screens/reup_recipe.dart';
  static const String othersUserProfile =
      '/lib/features/others_user_profile/screens/others_user_profile.dart';
  static const String resultSearch =
      '/lib/features/search_recipe/screens/result.dart';
  static const String suggestedRecipeCaculation =
      '/lib/features/ingredient_manager/screens/recipe_suggestion.dart';
  static String recipePlanDetail =
      '/lib/features/plan/screens/recipePlanDetail.dart';
  static String resultSearchRecipePlan =
      '/lib/features/plan/screens/resultSearchRecipePlan.dart';
  static String searchRecipePlan =
      '/lib/features/plan/screens/searchRecipePlan.dart';
  static String updatePlan = '/lib/features/plan/screens/updatePlan.dart';
  static String calculateIngredient =
      '/lib/features/plan/screens/caculateIngredient.dart';
  static String savedRecipeForPlan =
      '/lib/features/plan/screens/savedRecipeForPlan.dart';
  static String changePasswordUser =
      '/lib/features/password_setting/screen/change_password.dart';
  static String savedPlan = '/lib/features/plan/screens/savedPlan.dart';
  static String ingredientPreparePlan =
      'lib/features/plan/screens/ingredientPreparePlan.dart';
  static String notification =
      'lib/features/notification/screens/notification.dart';
  static String ingredientSection =
      'lib/features/ingredient_manager/screens/ingredient_section.dart';
}

final Map<String, WidgetBuilder> routes = {
  Routes.mainTab: (context) => const MainTabScreen(),
  Routes.signInWelcome: (context) => const SignInWelcomeScreen(),
  Routes.signIn: (context) => const SignInScreen(),
  Routes.signUp: (context) => const SignUpScreen(),
  Routes.addFood: (context) => const AddFoodScreen(),
  Routes.splash: (context) => const SplacshScreen(),
  Routes.ingredientManager: (context) => const FoodManagerScreen(),
  Routes.forgotPass: (context) => const EmailForm(),
  Routes.checkCode: (context) => const CodeFormScreen(),
  Routes.changeForgotPass: (context) => const ChangeForgotPassScreen(),
  Routes.home: (context) => HomeScreen(),
  Routes.ingredientDetail: (context) => const IngredientScreen(),
  Routes.recipeDetail: (context) => const RecipeScreen(),
  Routes.uploadRecipe: (context) => const UploadRecipeScreen(),
  Routes.userProfile: (context) => const UserProfileScreen(),
  Routes.editUserProfile: (context) => const EditUserProfileScreen(),
  Routes.uploadPost: (context) => const UploadPostScreen(),
  Routes.setting: (context) => const SettingScreen(),
  Routes.myRecipe: (context) => const MyRecipeScreen(),
  Routes.myPost: (context) => const MyPostScreen(),
  Routes.favoritePost: (context) => const FavoritePostScreen(),
  Routes.favoriteRecipe: (context) => const FavoriteRecipeScreen(),
  Routes.userProfile: (context) => const UserProfileScreen(),
  Routes.searchRecipe: (context) => const SearchRecipeScreen(),
  Routes.question: (context) => const QuestionScreen(),
  Routes.editRecipe: (context) => const EditRecipeScreen(),
  Routes.recipeDetailUser: (context) => const ViewRecipeScreen(),
  Routes.postDetailUser: (context) => const ViewPostScreen(),
  Routes.searchFood: (context) => const FoodSearchScreen(),
  Routes.searchPost: (context) => const SearchPostScreen(),
  Routes.editPost: (context) => const EditPostScreen(),
  Routes.plan: (context) => const PlanScreen(),
  Routes.signUpSuccess: (context) => const SignUpSuccessScreen(),
  Routes.activeCode: (context) => const ActiveCodeScreen(),
  Routes.changePassSuccess: (context) => const ChangePassSuccessScreen(),
  Routes.reupPost: (context) => const ReupPostScreen(),
  Routes.editIngredient: (context) => const UpdateIngredientScreen(),
  Routes.reupRecipe: (context) => const ReupRecipeScreen(),
  Routes.othersUserProfile: ((context) => const OthersUserProfileScreen()),
  Routes.resultSearch: ((context) => const ResultScreen()),
  Routes.suggestedRecipeCaculation: ((context) =>
      const SuggestedRecipeCaculationScreen()),
  Routes.recipePlanDetail: ((context) => const RecipePlanDetailScreen()),
  Routes.searchRecipePlan: ((context) => const SearchRecipePlanScreen()),
  Routes.resultSearchRecipePlan: ((context) =>
      const ResultSearchRecipePlanScreen()),
  Routes.updatePlan: ((context) => const UpdatePlanScreen()),
  Routes.calculateIngredient: ((context) => const CalculateIngredientScreen()),
  Routes.savedRecipeForPlan: ((context) => const SavedRecipeForPlanScreen()),
  Routes.changePasswordUser: ((context) => const ChangePasswordScreen()),
  Routes.savedPlan: ((context) => const SavedPlanScreen()),
  Routes.ingredientPreparePlan: ((context) =>
      const IngredientPreparePlanScreen()),
  Routes.notification: (((context) => const NotificationScreen())),
  Routes.ingredientSection: (((context) => const IngredientSectionScreen())),
};
