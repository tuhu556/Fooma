part of 'location_bloc.dart';

@immutable
class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object> get props => [];
}

class GetLocation extends LocationEvent {
  const GetLocation();
}

class GetLocationSuccess extends LocationEvent {
  final LocationResponse response;
  const GetLocationSuccess(this.response);
}

class GetLocationFailed extends LocationEvent {
  final ServerError error;
  const GetLocationFailed(this.error);
}
