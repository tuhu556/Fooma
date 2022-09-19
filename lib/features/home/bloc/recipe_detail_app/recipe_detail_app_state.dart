part of 'recipe_detail_app_bloc.dart';

@immutable
class RecipeDetailAppState extends Equatable {
  final RecipeDetailStatus status;

  RecipeDetailAppModel? recipeAppModel;
  ServerError? error;
  RecipeDetailAppState({
    required this.status,
    this.recipeAppModel,
  });
  @override
  List<Object> get props => [status];
  RecipeDetailAppState copyWith(
    RecipeDetailStatus? status,
    RecipeDetailAppModel? recipeAppModel,
    ServerError? error,
  ) {
    var newState = RecipeDetailAppState(status: status ?? this.status);
    print(recipeAppModel);
    if (recipeAppModel != null) {
      newState.recipeAppModel = recipeAppModel;
    }
    if (error != null) {
      newState.error = error;
    }

    return newState;
  }
}

enum RecipeDetailStatus {
  Initial,
  Processing,
  Success,
  Failed,
}
