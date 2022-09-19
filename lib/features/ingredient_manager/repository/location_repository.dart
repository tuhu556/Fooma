import 'package:flutter/material.dart';
import 'package:foodhub/features/ingredient_manager/models/location_entity.dart';

import 'package:foodhub/service/networking.dart';
import 'package:foodhub/config/endpoint.dart';

class LocationRepository extends Networking {
  void getLocation(
    ValueSetter<dynamic> completion,
  ) {
    final configuration = RequestConfiguration(HTTPMethod.Get,
        Path.shared.pathGetLocationIngredient, null, null, null);

    executeRequest(
      configuration,
      (response) {
        if (response.data != null) {
          final dataJson = response.data;
          final locationRespone = LocationResponse.fromJson(dataJson);

          completion(locationRespone);
        } else {
          completion(response.error ?? ServerError.internalError());
        }
      },
    );
  }
}
