import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/features/password_setting/repository/change_password_repository.dart';
import 'package:foodhub/service/networking.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  ChangePasswordBloc()
      : super(ChangePasswordState(status: ChangePasswordStatus.Initial));
  @override
  Stream<ChangePasswordState> mapEventToState(
    ChangePasswordEvent event,
  ) async* {
    if (event is ChangePassword) {
      yield state.copyWith(ChangePasswordStatus.Processing, null);
      yield* _mapChangePasswordState(event);
    } else if (event is ChangePasswordSuccess) {
      yield state.copyWith(ChangePasswordStatus.Success, null);
    } else if (event is ChangePasswordFailed) {
      yield state.copyWith(ChangePasswordStatus.Failed, event.error);
    }
  }

  Stream<ChangePasswordState> _mapChangePasswordState(
      ChangePassword event) async* {
    final repository = ChangePasswordRepository();
    final params = state.createParameters;
    params["oldPassword"] = event.oldPassword;
    params["newPassword"] = event.newPassword;

    print(params);

    try {
      repository.changePass(params, (data) {
        if (data is int && (data == 200)) {
          add(const ChangePasswordSuccess());
        } else {
          add(ChangePasswordFailed(data as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(
          ChangePasswordStatus.Failed, ServerError.internalError());
    }
  }
}
