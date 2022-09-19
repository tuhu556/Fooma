part of 'ingredient_data_bloc.dart';

@immutable
class IngredientDataState extends Equatable {
  final IngredientDataStatus status;
  IngredientResponse? ingredientResponse;
  IngredientDataModel? ingredientData;

  ServerError? error;

  IngredientDataState({required this.status, this.ingredientData});

  List<Object> get props => [status];

  IngredientDataState copyWith(
      IngredientDataStatus? status,
      IngredientResponse? ingredientResponse,
      IngredientDataModel? ingredientData,
      ServerError? error) {
    var newState = IngredientDataState(status: status ?? this.status);

    if (ingredientResponse != null) {
      newState.ingredientResponse = ingredientResponse;
    }
    if (ingredientData != null) {
      newState.ingredientData = ingredientData;
    }

    if (error != null) {
      newState.error = error;
    }

    return newState;
  }
}

enum IngredientDataStatus {
  Initial,
  Processing,
  Success,
  Failed,
}
