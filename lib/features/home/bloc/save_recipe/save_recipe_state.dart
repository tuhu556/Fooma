part of 'save_recipe_bloc.dart';

@immutable
class SaveRecipeState extends Equatable {
  final SaveRecipeStatus status;
  Map<String, dynamic> createParameters = {};
  ServerError? error;
  SaveRecipeState({required this.status});

  @override
  List<Object> get props => [status];
  SaveRecipeState copyWith(SaveRecipeStatus? status, ServerError? error) {
    var newState = SaveRecipeState(status: status ?? this.status);

    newState.createParameters = createParameters;

    if (error != null) {
      newState.error = error;
    }

    return newState;
  }
}

enum SaveRecipeStatus {
  Initial,
  Processing,
  Success,
  Failed,
}
