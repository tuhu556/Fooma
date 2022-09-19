part of 'origin_recipe_bloc.dart';

@immutable
class OriginRecipeState extends Equatable {
  final OriginStatus status;
  OriginResponse? originResponse;
  OriginModel? data;
  ServerError? error;
  OriginRecipeState({
    required this.status,
    this.data,
  });

  @override
  List<Object> get props => [status];
  OriginRecipeState copyWith(
    OriginStatus? status,
    OriginResponse? response,
    OriginModel? dataResponse,
    ServerError? error,
  ) {
    var newState = OriginRecipeState(status: status ?? this.status);
    if (response != null) {
      newState.originResponse = response;
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

enum OriginStatus {
  Initial,
  Processing,
  Success,
  Failed,
}
