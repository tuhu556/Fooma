part of 'upload_recipe_bloc.dart';

@immutable
class UploadRecipeState extends Equatable {
  final UploadRecipeStatus status;
  Map<String, dynamic> uploadRecipeParameters = {};

  ServerError? error;

  UploadRecipeState({required this.status});

  List<Object> get props => [status];

  UploadRecipeState copyWith(UploadRecipeStatus? status, ServerError? error) {
    var newState = UploadRecipeState(status: status ?? this.status);

    newState.uploadRecipeParameters = uploadRecipeParameters;

    if (error != null) {
      newState.error = error;
    }

    return newState;
  }
}

enum UploadRecipeStatus {
  Initial,
  Processing,
  Success,
  Failed,
}
