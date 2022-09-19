part of 'recipe_suggestion_bloc.dart';

@immutable
class RecipeSuggestionEvent extends Equatable {
  const RecipeSuggestionEvent();

  @override
  List<Object> get props => [];
}

class RecipeSuggestion extends RecipeSuggestionEvent {
  final int page;
  final int size;
  final String sortOption;
  const RecipeSuggestion(
    this.page,
    this.size,
    this.sortOption,
  );
}

class GetRecipeSuggestionSuccess extends RecipeSuggestionEvent {
  final RecipeAppResponse data;
  const GetRecipeSuggestionSuccess(this.data);
}

class GetRecipeSuggestionFailed extends RecipeSuggestionEvent {
  final ServerError error;
  const GetRecipeSuggestionFailed(this.error);
}
