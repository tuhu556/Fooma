part of 'ingredient_data_bloc.dart';

@immutable
class IngredientDataEvent extends Equatable {
  const IngredientDataEvent();

  @override
  List<Object> get props => [];
}

class IngredientData extends IngredientDataEvent {
  final int size;
  const IngredientData(this.size);
}

class GetIngredientDataSuccess extends IngredientDataEvent {
  final IngredientResponse data;
  const GetIngredientDataSuccess(this.data);
}

class GetIngredientDataFailed extends IngredientDataEvent {
  final ServerError error;
  const GetIngredientDataFailed(this.error);
}
