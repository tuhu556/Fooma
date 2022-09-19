part of 'remove_device_id_bloc.dart';

@immutable
class RemoveDeviceIdState extends Equatable {
  final RemoveStatus status;
  Map<String, dynamic> createParameters = {};
  ServerError? error;
  RemoveDeviceIdState({required this.status});

  @override
  List<Object> get props => [status];
  RemoveDeviceIdState copyWith(RemoveStatus? status, ServerError? error) {
    var newState = RemoveDeviceIdState(status: status ?? this.status);

    newState.createParameters = createParameters;

    if (error != null) {
      newState.error = error;
    }

    return newState;
  }
}

enum RemoveStatus {
  Initial,
  Processing,
  Success,
  Failed,
}
