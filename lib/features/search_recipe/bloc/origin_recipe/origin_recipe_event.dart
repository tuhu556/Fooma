part of 'origin_recipe_bloc.dart';

@immutable
class OriginRecipeEvent extends Equatable {
  const OriginRecipeEvent();

  @override
  List<Object> get props => [];
}

class OriginRecipe extends OriginRecipeEvent {
  final int page;
  final int size;

  const OriginRecipe(
    this.page,
    this.size,
  );
}

class GetOriginSuccess extends OriginRecipeEvent {
  final OriginResponse data;
  const GetOriginSuccess(this.data);
}

class GetOriginFailed extends OriginRecipeEvent {
  final ServerError error;
  const GetOriginFailed(this.error);
}
