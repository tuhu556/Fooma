import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodhub/features/home/models/recipe_app_entity.dart';
import 'package:foodhub/features/home/repository/recipe_suggestion_repistory.dart';
import 'package:foodhub/service/networking.dart';

part 'recipe_suggestion_event.dart';
part 'recipe_suggestion_state.dart';

class RecipeSuggestionBloc
    extends Bloc<RecipeSuggestionEvent, RecipeSuggestionState> {
  RecipeSuggestionBloc()
      : super(RecipeSuggestionState(status: RecipeSuggestionStatus.Initial));
  @override
  Stream<RecipeSuggestionState> mapEventToState(
    RecipeSuggestionEvent event,
  ) async* {
    if (event is RecipeSuggestion) {
      yield state.copyWith(
        RecipeSuggestionStatus.Processing,
        null,
        null,
        null,
      );
      yield* _mapGetRecipeSuggestionToState(event);
    } else if (event is GetRecipeSuggestionSuccess) {
      yield state.copyWith(
        RecipeSuggestionStatus.Success,
        event.data,
        null,
        null,
      );
    } else if (event is GetRecipeSuggestionFailed) {
      yield state.copyWith(
          RecipeSuggestionStatus.Failed, null, null, event.error);
    }
  }

  Stream<RecipeSuggestionState> _mapGetRecipeSuggestionToState(
      RecipeSuggestion event) async* {
    final repository = RecipeSuggestionRepository();

    try {
      repository.getRecipeSuggestion(event.page, event.size, event.sortOption,
          (value) {
        if (value is RecipeAppResponse) {
          add(GetRecipeSuggestionSuccess(value));
        } else {
          add(GetRecipeSuggestionFailed(value as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(RecipeSuggestionStatus.Failed, null, null,
          ServerError.internalError());
    }
  }
}
