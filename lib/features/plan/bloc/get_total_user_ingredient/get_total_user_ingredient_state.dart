part of 'get_total_user_ingredient_bloc.dart';

@immutable
class GetTotalUserIngredientState extends Equatable {
  final IngredientTotalStatus status;
  IngredientTotalResponse? ingredientUserResponse;
  IngredientUserModel? ingredientUserData;
  ServerError? error;

  GetTotalUserIngredientState({required this.status, this.ingredientUserData});
  @override
  List<Object> get props => [status];
  GetTotalUserIngredientState copyWith(
      IngredientTotalStatus? status,
      IngredientTotalResponse? ingredientUserResponse,
      IngredientUserModel? ingredientUserData,
      ServerError? error) {
    var newState = GetTotalUserIngredientState(status: status ?? this.status);

    if (ingredientUserResponse != null) {
      newState.ingredientUserResponse = ingredientUserResponse;
    }
    if (ingredientUserData != null) {
      newState.ingredientUserData = ingredientUserData;
    }

    if (error != null) {
      newState.error = error;
    }

    return newState;
  }
}

enum IngredientTotalStatus {
  Initial,
  Processing,
  Success,
  Failed,
}
