import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/features/ingredient_manager/models/location_entity.dart';
import 'package:foodhub/features/ingredient_manager/repository/location_repository.dart';
import 'package:foodhub/service/networking.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationState(status: LocationStatus.Initial));
  @override
  Stream<LocationState> mapEventToState(
    LocationEvent event,
  ) async* {
    if (event is GetLocation) {
      yield state.copyWith(LocationStatus.Processing, null, null, null);
      yield* _maplocationToState(event);
    } else if (event is GetLocationSuccess) {
      yield state.copyWith(LocationStatus.Success, event.response, null, null);
    } else if (event is GetLocationFailed) {
      yield state.copyWith(LocationStatus.Failed, null, null, event.error);
    }
  }

  Stream<LocationState> _maplocationToState(GetLocation event) async* {
    final repository = LocationRepository();

    try {
      repository.getLocation((value) {
        if (value is LocationResponse) {
          add(GetLocationSuccess(value));
        } else {
          add(GetLocationFailed(value as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(
          LocationStatus.Failed, null, null, ServerError.internalError());
    }
  }
}
