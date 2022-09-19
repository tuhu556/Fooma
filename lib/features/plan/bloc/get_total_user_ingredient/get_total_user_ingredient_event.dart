part of 'get_total_user_ingredient_bloc.dart';

@immutable
class GetTotalUserIngredientEvent extends Equatable {
  const GetTotalUserIngredientEvent();

  @override
  List<Object> get props => [];
}

class IngredientTotal extends GetTotalUserIngredientEvent {
  const IngredientTotal();
}

class GetIngredientTotalSuccess extends GetTotalUserIngredientEvent {
  final IngredientTotalResponse data;
  const GetIngredientTotalSuccess(this.data);
}

class GetIngredientTotalFailed extends GetTotalUserIngredientEvent {
  final ServerError error;
  const GetIngredientTotalFailed(this.error);
}
