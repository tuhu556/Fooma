import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodhub/features/ingredient_manager/models/ingredient_category_entity.dart';
import 'package:foodhub/features/ingredient_manager/repository/ingredient_category_repository.dart';
import 'package:foodhub/service/networking.dart';

part 'ingredient_category_event.dart';
part 'ingredient_category_state.dart';

class IngredientCategoryBloc
    extends Bloc<IngredientCategoryEvent, IngredientCategoryState> {
  IngredientCategoryBloc()
      : super(
            IngredientCategoryState(status: IngredientCategoryStatus.Initial));
  @override
  Stream<IngredientCategoryState> mapEventToState(
    IngredientCategoryEvent event,
  ) async* {
    if (event is IngredientCateogy) {
      yield state.copyWith(
          IngredientCategoryStatus.Processing, null, null, null);
      yield* _mapIngredientCategoryToState(event);
    } else if (event is GetIngredientCategorySuccess) {
      yield state.copyWith(
          IngredientCategoryStatus.Success, event.response, null, null);
    } else if (event is GetIngredientCategoryFailed) {
      yield state.copyWith(
          IngredientCategoryStatus.Failed, null, null, event.error);
    }
  }

  Stream<IngredientCategoryState> _mapIngredientCategoryToState(
      IngredientCateogy event) async* {
    final repository = IngredientCategoryRepository();

    try {
      repository.getIngredientCategoryData((value) {
        if (value is IngredientCategoryResponse) {
          add(GetIngredientCategorySuccess(value));
        } else {
          add(GetIngredientCategoryFailed(value as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(IngredientCategoryStatus.Failed, null, null,
          ServerError.internalError());
    }
  }
}
