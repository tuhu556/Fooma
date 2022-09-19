import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:equatable/equatable.dart';
import 'package:foodhub/features/forgot_password/repository/verify_code_repository.dart';

import 'package:foodhub/service/networking.dart';

part 'verify_code_event.dart';
part 'verify_code_state.dart';

class VerifyCodeBloc extends Bloc<VerifyCodeEvent, VerifyCodeState> {
  VerifyCodeBloc() : super(VerifyCodeState(status: VerifyCodeStatus.Initial));
  @override
  Stream<VerifyCodeState> mapEventToState(
    VerifyCodeEvent event,
  ) async* {
    if (event is CreateVerifyCodeEvent) {
      yield state.copyWith(VerifyCodeStatus.Processing, null, null);
      yield* _mapVerifyCodeState(event);
    } else if (event is VerifyCodeSuccess) {
      yield state.copyWith(VerifyCodeStatus.Success, event.keyCode, null);
    } else if (event is VerifyCodeFailed) {
      yield state.copyWith(VerifyCodeStatus.Failed, null, event.error);
    }
  }

  Stream<VerifyCodeState> _mapVerifyCodeState(
      CreateVerifyCodeEvent event) async* {
    final repository = VerifyCodeRestRepository();
    final params = state.createCodeParameters;
    params["email"] = event.email;
    params["code"] = event.code;

    print(params);

    try {
      repository.verifyCode(params, (data) {
        if (data is String) {
          print(data);
          add(VerifyCodeSuccess(data));
        } else {
          add(VerifyCodeFailed(data as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(
          VerifyCodeStatus.Failed, null, ServerError.internalError());
    }
  }
}
