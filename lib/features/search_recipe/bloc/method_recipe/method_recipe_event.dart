part of 'method_recipe_bloc.dart';

@immutable
class MethodRecipeEvent extends Equatable {
  const MethodRecipeEvent();

  @override
  List<Object> get props => [];
}

class MethodRecipe extends MethodRecipeEvent {
  final int page;
  final int size;

  const MethodRecipe(
    this.page,
    this.size,
  );
}

class GetMethodSuccess extends MethodRecipeEvent {
  final MethodRecipeResponse data;
  const GetMethodSuccess(this.data);
}

class GetMethodFailed extends MethodRecipeEvent {
  final ServerError error;
  const GetMethodFailed(this.error);
}
