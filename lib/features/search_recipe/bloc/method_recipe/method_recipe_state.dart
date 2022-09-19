part of 'method_recipe_bloc.dart';

@immutable
class MethodRecipeState extends Equatable {
  final MethodStatus status;
  MethodRecipeResponse? methodResponse;
  MethodRecipeModel? data;
  ServerError? error;
  MethodRecipeState({
    required this.status,
    this.data,
  });

  @override
  List<Object> get props => [status];
  MethodRecipeState copyWith(
    MethodStatus? status,
    MethodRecipeResponse? response,
    MethodRecipeModel? dataResponse,
    ServerError? error,
  ) {
    var newState = MethodRecipeState(status: status ?? this.status);
    if (response != null) {
      newState.methodResponse = response;
    }
    if (dataResponse != null) {
      newState.data = dataResponse;
    }

    if (error != null) {
      newState.error = error;
    }

    return newState;
  }
}

enum MethodStatus {
  Initial,
  Processing,
  Success,
  Failed,
}
