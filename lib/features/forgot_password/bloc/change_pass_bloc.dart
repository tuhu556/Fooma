import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:equatable/equatable.dart';
import 'package:foodhub/features/forgot_password/repository/change_pass_repository.dart';

import 'package:foodhub/service/networking.dart';

part 'change_pass_event.dart';
part 'change_pass_state.dart';

class ChangePassBloc extends Bloc<ChangePassEvent, ChangePassState> {
  ChangePassBloc() : super(ChangePassState(status: ChangePassStatus.Initial));
  @override
  Stream<ChangePassState> mapEventToState(
    ChangePassEvent event,
  ) async* {
    if (event is CreateChangePassEvent) {
      yield state.copyWith(ChangePassStatus.Processing, null);
      yield* _mapChangePassState(event);
    } else if (event is ChangePassSuccess) {
      yield state.copyWith(ChangePassStatus.Success, null);
    } else if (event is ChangePassFailed) {
      yield state.copyWith(ChangePassStatus.Failed, event.error);
    }
  }

  Stream<ChangePassState> _mapChangePassState(
      CreateChangePassEvent event) async* {
    final repository = ChangePassRestRepository();
    final params = state.createPasswordParameters;
    params["email"] = event.email;
    params["code"] = event.keyCode;
    params["password"] = event.password;

    print(params);

    try {
      repository.changePass(params, (data) {
        if (data is int && (data == 200)) {
          add(const ChangePassSuccess());
        } else {
          add(ChangePassFailed(data as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(
          ChangePassStatus.Failed, ServerError.internalError());
    }
  }
}
