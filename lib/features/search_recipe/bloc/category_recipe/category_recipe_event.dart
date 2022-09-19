part of 'category_recipe_bloc.dart';

@immutable
class CategoryRecipeEvent extends Equatable {
  const CategoryRecipeEvent();

  @override
  List<Object> get props => [];
}

class CategoryRecipe extends CategoryRecipeEvent {
  final int page;
  final int size;

  const CategoryRecipe(
    this.page,
    this.size,
  );
}

class GetCategorySuccess extends CategoryRecipeEvent {
  final CategoryRecipeResponse data;
  const GetCategorySuccess(this.data);
}

class GetCategoryFailed extends CategoryRecipeEvent {
  final ServerError error;
  const GetCategoryFailed(this.error);
}
