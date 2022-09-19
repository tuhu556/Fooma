import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/session/session.dart';

import '../../../service/networking.dart';
import '../repository/edit_user_profile_repository.dart';

part 'edit_user_profile_event.dart';
part 'edit_user_profile_state.dart';

class EditUserProfileBloc
    extends Bloc<UpdateUserProfileEvent, EditUserProfileState> {
  EditUserProfileBloc()
      : super(EditUserProfileState(status: EditUserProfileStatus.Initial));

  @override
  Stream<EditUserProfileState> mapEventToState(
    UpdateUserProfileEvent event,
  ) async* {
    if (event is EditUserProfileEvent) {
      yield state.copyWith(EditUserProfileStatus.Processing, null);
      yield* _mapEditUserProfileState(event);
    } else if (event is EditUserProfileSuccess) {
      yield state.copyWith(EditUserProfileStatus.Success, null);
    } else if (event is EditUserProfileFailed) {
      yield state.copyWith(EditUserProfileStatus.Failed, event.error);
    }
  }

  Stream<EditUserProfileState> _mapEditUserProfileState(
      EditUserProfileEvent event) async* {
    final repository = EditUserProfileRestRepository();
    final params = state.updateUserParameters;
    params["name"] = event.name;
    params["birthDate"] = event.birthDate;
    params["phoneNumber"] = event.phoneNumber;
    params["imageUrl"] = event.imageUrl;
    params["bio"] = event.bio;
    print(params);

    try {
      repository.editUserProfile(params, (data) {
        if (data is int && data == 200) {
          add(const EditUserProfileSuccess());
        } else {
          add(EditUserProfileFailed(data as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(
          EditUserProfileStatus.Failed, ServerError.internalError());
    }
  }
}
