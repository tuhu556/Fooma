part of 'unsave_recipe_bloc.dart';

@immutable
class UnsaveRecipeState extends Equatable {
  final UnSaveRecipeStatus status;
  Map<String, dynamic> createParameters = {};
  ServerError? error;
  UnsaveRecipeState({required this.status});

  @override
  List<Object> get props => [status];
  UnsaveRecipeState copyWith(UnSaveRecipeStatus? status, ServerError? error) {
    var newState = UnsaveRecipeState(status: status ?? this.status);

    newState.createParameters = createParameters;

    if (error != null) {
      newState.error = error;
    }

    return newState;
  }
}

enum UnSaveRecipeStatus {
  Initial,
  Processing,
  Success,
  Failed,
}
