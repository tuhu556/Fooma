part of 'edit_recipe_bloc.dart';

@immutable
class EditMyRecipeState extends Equatable {
  final EditMyRecipeStatus status;
  Map<String, dynamic> editMyRecipeParameters = {};
  ServerError? error;

  EditMyRecipeState({required this.status});

  List<Object> get props => [status];

  EditMyRecipeState copyWith(EditMyRecipeStatus? status, ServerError? error) {
    var newState = EditMyRecipeState(status: status ?? this.status);

    newState.editMyRecipeParameters = editMyRecipeParameters;

    if (error != null) {
      newState.error = error;
    }

    return newState;
  }
}

enum EditMyRecipeStatus {
  Initial,
  Processing,
  Success,
  Failed,
}
