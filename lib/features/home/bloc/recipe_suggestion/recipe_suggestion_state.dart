part of 'recipe_suggestion_bloc.dart';

@immutable
class RecipeSuggestionState extends Equatable {
  final RecipeSuggestionStatus status;
  RecipeAppResponse? recipeResponse;
  RecipeAppModel? recipeAppModel;

  ServerError? error;
  RecipeSuggestionState({
    required this.status,
    this.recipeAppModel,
  });

  @override
  List<Object> get props => [status];
  RecipeSuggestionState copyWith(
    RecipeSuggestionStatus? status,
    RecipeAppResponse? recipeResponse,
    RecipeAppModel? recipeAppModel,
    ServerError? error,
  ) {
    var newState = RecipeSuggestionState(status: status ?? this.status);

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

enum RecipeSuggestionStatus {
  Initial,
  Processing,
  Success,
  Failed,
}
