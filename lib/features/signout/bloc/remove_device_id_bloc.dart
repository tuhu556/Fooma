import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodhub/features/signout/repository/remove_device_id_repository.dart';
import 'package:foodhub/service/networking.dart';

part 'remove_device_id_event.dart';
part 'remove_device_id_state.dart';

class RemoveDeviceIdBloc
    extends Bloc<RemoveDeviceIdEvent, RemoveDeviceIdState> {
  RemoveDeviceIdBloc()
      : super(RemoveDeviceIdState(status: RemoveStatus.Initial));

  @override
  Stream<RemoveDeviceIdState> mapEventToState(
    RemoveDeviceIdEvent event,
  ) async* {
    if (event is RemoveDeviceId) {
      yield state.copyWith(RemoveStatus.Processing, null);
      yield* _mapState(event);
    } else if (event is RemoveDeviceIdSuccess) {
      yield state.copyWith(RemoveStatus.Success, null);
    } else if (event is RemoveDeviceIdFailed) {
      yield state.copyWith(RemoveStatus.Failed, event.error);
    }
  }

  Stream<RemoveDeviceIdState> _mapState(RemoveDeviceId event) async* {
    final repository = RemoveDeviceIdRepository();
    final params = state.createParameters;
    params["deviceId"] = event.deviceId;

    try {
      repository.removeDeviceId(params, (data) {
        if (data is int && (data == 200)) {
          add(const RemoveDeviceIdSuccess());
        } else {
          add(RemoveDeviceIdFailed(data as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(RemoveStatus.Failed, ServerError.internalError());
    }
  }
}
