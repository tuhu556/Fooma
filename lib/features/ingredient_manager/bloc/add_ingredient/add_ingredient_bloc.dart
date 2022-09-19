import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodhub/features/ingredient_manager/repository/add_ingredient_repository.dart';
import 'package:foodhub/service/networking.dart';

import '../../models/ingredient_user_entity.dart';

part 'add_ingredient_event.dart';
part 'add_ingredient_state.dart';

class AddIngredientBloc extends Bloc<AddIngredientEvent, AddIngredientState> {
  AddIngredientBloc()
      : super(AddIngredientState(status: AddIngredientStatus.Initial));
  @override
  Stream<AddIngredientState> mapEventToState(
    AddIngredientEvent event,
  ) async* {
    if (event is CreateIngredientEvent) {
      yield state.copyWith(AddIngredientStatus.Processing, null);
      yield* _mapIngredientState(event);
    } else if (event is AddIngredientSuccess) {
      yield state.copyWith(AddIngredientStatus.Success, null);
    } else if (event is AddIngredientFailed) {
      yield state.copyWith(AddIngredientStatus.Failed, event.error);
    }
  }

  Stream<AddIngredientState> _mapIngredientState(
      CreateIngredientEvent event) async* {
    final repository = AddIngredientRepository();
    final params = state.createIngredientParameters;
    params["ingredientDbid"] = event.ingredientDbid;
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
      for (int i = 0; i < event.ingredientNotifications!.length; i++)
        {
          "ingredientNotificationId":
              event.ingredientNotifications![i].ingredientNotificationId,
        }
    ];

    try {
      repository.CreateIngredient(params, (data) {
        if (data is int && (data == 200)) {
          add(const AddIngredientSuccess());
        } else {
          add(AddIngredientFailed(data as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(
          AddIngredientStatus.Failed, ServerError.internalError());
    }
  }
}
