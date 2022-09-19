part of 'location_bloc.dart';

@immutable
class LocationState extends Equatable {
  final LocationStatus status;
  LocationResponse? locationResponse;
  LocationModel? locationModel;
  ServerError? error;
  LocationState({
    required this.status,
    this.locationModel,
  });

  @override
  List<Object> get props => [status];
  LocationState copyWith(
    LocationStatus? status,
    LocationResponse? response,
    LocationModel? dataResponse,
    ServerError? error,
  ) {
    var newState = LocationState(status: status ?? this.status);
    if (response != null) {
      newState.locationResponse = response;
    }
    if (dataResponse != null) {
      newState.locationModel = dataResponse;
    }

    if (error != null) {
      newState.error = error;
    }

    return newState;
  }
}

enum LocationStatus {
  Initial,
  Processing,
  Success,
  Failed,
}
