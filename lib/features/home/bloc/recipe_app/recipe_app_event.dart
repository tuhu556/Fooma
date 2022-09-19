part of 'recipe_app_bloc.dart';

@immutable
class RecipeAppEvent extends Equatable {
  const RecipeAppEvent();

  @override
  List<Object> get props => [];
}

class RecipeApp extends RecipeAppEvent {
  final int page;
  final int size;
  final String sortOption;
  final String search;
  final String category;
  final String country;
  final String method;
  final int time;
  final int role;
  const RecipeApp(this.page, this.size, this.sortOption, this.search,
      this.category, this.country, this.method, this.time, this.role);
}

class GetRecipeAppSuccess extends RecipeAppEvent {
  final RecipeAppResponse data;
  const GetRecipeAppSuccess(this.data);
}

class GetRecipeAppFailed extends RecipeAppEvent {
  final ServerError error;
  const GetRecipeAppFailed(this.error);
}
