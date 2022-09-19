part of 'remove_device_id_bloc.dart';

@immutable
class RemoveDeviceIdEvent extends Equatable {
  const RemoveDeviceIdEvent();

  @override
  List<Object> get props => [];
}

class RemoveDeviceId extends RemoveDeviceIdEvent {
  String deviceId;
  RemoveDeviceId(this.deviceId);
}

class RemoveDeviceIdSuccess extends RemoveDeviceIdEvent {
  const RemoveDeviceIdSuccess();
}

class RemoveDeviceIdFailed extends RemoveDeviceIdEvent {
  final ServerError error;
  const RemoveDeviceIdFailed(this.error);
}
