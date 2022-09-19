part of 'ingredient_user_bloc.dart';

@immutable
class IngredientUserState extends Equatable {
  final IngredientUserStatus status;
  IngredientUserResponse? ingredientUserResponse;
  IngredientUserModel? ingredientUserData;
  ServerError? error;

  IngredientUserState({required this.status, this.ingredientUserData});
  @override
  List<Object> get props => [status];
  IngredientUserState copyWith(
      IngredientUserStatus? status,
      IngredientUserResponse? ingredientUserResponse,
      IngredientUserModel? ingredientUserData,
      ServerError? error) {
    var newState = IngredientUserState(status: status ?? this.status);

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

enum IngredientUserStatus {
  Initial,
  Processing,
  Success,
  Failed,
}
