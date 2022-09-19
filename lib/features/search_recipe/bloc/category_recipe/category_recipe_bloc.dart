import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodhub/features/home/models/recipe_app_entity.dart';
import 'package:foodhub/features/search_recipe/model/category_recipe_entity.dart';
import 'package:foodhub/features/search_recipe/repository/category_recipe_repository.dart';
import 'package:foodhub/service/networking.dart';

part 'category_recipe_event.dart';
part 'category_recipe_state.dart';

class CategoryRecipeBloc
    extends Bloc<CategoryRecipeEvent, CategoryRecipeState> {
  CategoryRecipeBloc()
      : super(CategoryRecipeState(status: CategoryStatus.Initial));
  @override
  Stream<CategoryRecipeState> mapEventToState(
    CategoryRecipeEvent event,
  ) async* {
    if (event is CategoryRecipe) {
      yield state.copyWith(CategoryStatus.Processing, null, null, null);
      yield* _mapCategoryRecipeToState(event);
    } else if (event is GetCategorySuccess) {
      yield state.copyWith(CategoryStatus.Success, event.data, null, null);
    } else if (event is GetCategoryFailed) {
      yield state.copyWith(CategoryStatus.Failed, null, null, event.error);
    }
  }

  Stream<CategoryRecipeState> _mapCategoryRecipeToState(
      CategoryRecipe event) async* {
    final repository = CategoryRecipeRepository();

    try {
      repository.getCategoryRecipe(event.page, event.size, (value) {
        if (value is CategoryRecipeResponse) {
          add(GetCategorySuccess(value));
        } else {
          add(GetCategoryFailed(value as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(
          CategoryStatus.Failed, null, null, ServerError.internalError());
    }
  }
}
