import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodhub/features/ingredient_manager/repository/update_ingredient_repository.dart';
import 'package:foodhub/service/networking.dart';

import '../../models/ingredient_user_entity.dart';

part 'update_ingredient_event.dart';
part 'update_ingredient_state.dart';

class UpdateIngredientBloc
    extends Bloc<UpdateIngredientEvent, UpdateIngredientState> {
  UpdateIngredientBloc()
      : super(UpdateIngredientState(status: UpdateIngredientStatus.Initial));
  @override
  Stream<UpdateIngredientState> mapEventToState(
    UpdateIngredientEvent event,
  ) async* {
    if (event is CreateUpdateIngredientEvent) {
      yield state.copyWith(UpdateIngredientStatus.Processing, null);
      yield* _mapIngredientState(event);
    } else if (event is UpdateIngredientSuccess) {
      yield state.copyWith(UpdateIngredientStatus.Success, null);
    } else if (event is UpdateIngredientNothing) {
      yield state.copyWith(UpdateIngredientStatus.NothingChange, null);
    } else if (event is UpdateIngredientFailed) {
      yield state.copyWith(UpdateIngredientStatus.Failed, event.error);
    }
  }

  Stream<UpdateIngredientState> _mapIngredientState(
      CreateUpdateIngredientEvent event) async* {
    final repository = UpdateIngredientRepository();
    final params = state.createIngredientParameters;
    params["categoryId"] = event.categoryId;
    params['locationId'] = event.locationId;
    params['locationname'] = event.locationName;
    params["ingredientName"] = event.ingredientName;
    params["expiredDate"] = event.expiredDate;
    params["quantity"] = event.quantity;
    params["desciption"] = event.desciption;
    params["imageUrl"] = event.imageUrl;
    params["unit"] = event.unit;
    params["ingredientNotifications"] = [
      for (int i = 0; i < event.ingredientNotifications.length; i++)
        {
          "ingredientNotificationId":
              event.ingredientNotifications[i].ingredientNotificationId,
        }
    ];

    try {
      repository.updateIngredient(event.ingredientId, params, (data) {
        if (data is int && (data == 200)) {
          add(const UpdateIngredientSuccess());
        } else if (data == 204) {
          add(const UpdateIngredientNothing());
        } else {
          add(UpdateIngredientFailed(data as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(
          UpdateIngredientStatus.Failed, ServerError.internalError());
    }
  }
}
