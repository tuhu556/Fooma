part of 'ingredient_category_bloc.dart';

@immutable
class IngredientCategoryEvent extends Equatable {
  const IngredientCategoryEvent();

  @override
  List<Object> get props => [];
}

class IngredientCateogy extends IngredientCategoryEvent {
  const IngredientCateogy();
}

class GetIngredientCategorySuccess extends IngredientCategoryEvent {
  final IngredientCategoryResponse response;
  const GetIngredientCategorySuccess(this.response);
}

class GetIngredientCategoryFailed extends IngredientCategoryEvent {
  final ServerError error;
  const GetIngredientCategoryFailed(this.error);
}
