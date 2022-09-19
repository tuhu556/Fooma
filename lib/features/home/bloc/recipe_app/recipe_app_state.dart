part of 'recipe_app_bloc.dart';

@immutable
class RecipeAppState extends Equatable {
  final RecipeAppStatus status;
  RecipeAppResponse? recipeResponse;
  RecipeAppModel? recipeAppModel;
  ServerError? error;
  RecipeAppState({
    required this.status,
    this.recipeAppModel,
  });

  @override
  List<Object> get props => [status];
  RecipeAppState copyWith(
    RecipeAppStatus? status,
    RecipeAppResponse? recipeResponse,
    RecipeAppModel? recipeAppModel,
    ServerError? error,
  ) {
    var newState = RecipeAppState(status: status ?? this.status);

    if (recipeResponse != null) {
      newState.recipeResponse = recipeResponse;
    }
    if (recipeAppModel != null) {
      newState.recipeAppModel = recipeAppModel;
    }
    if (error != null) {
      newState.error = error;
    }

    return newState;
  }
}

enum RecipeAppStatus {
  Initial,
  Processing,
  Success,
  Failed,
}
