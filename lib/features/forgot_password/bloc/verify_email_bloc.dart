import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:equatable/equatable.dart';
import 'package:foodhub/features/forgot_password/repository/verify_email_repository.dart';
import 'package:foodhub/service/networking.dart';

part 'verify_email_event.dart';
part 'verify_email_state.dart';

class VerifyEmailBloc extends Bloc<VerifyEmailEvent, VerifyEmailState> {
  VerifyEmailBloc()
      : super(VerifyEmailState(status: VerifyEmailStatus.Initial));
  @override
  Stream<VerifyEmailState> mapEventToState(
    VerifyEmailEvent event,
  ) async* {
    if (event is CreateVerifyEmailEvent) {
      yield state.copyWith(VerifyEmailStatus.Processing, null);
      yield* _mapVerifyEmailState(event);
    } else if (event is VerifyEmailSuccess) {
      yield state.copyWith(VerifyEmailStatus.Success, null);
    } else if (event is VerifyEmailFailed) {
      yield state.copyWith(VerifyEmailStatus.Failed, event.error);
    }
  }

  Stream<VerifyEmailState> _mapVerifyEmailState(
      CreateVerifyEmailEvent event) async* {
    final repository = VerifyEmailRestRepository();
    final params = state.createEmailParameters;
    params["email"] = event.email;

    print(params);

    try {
      repository.verifyEmail(params, (data) {
        if (data is int && (data == 200)) {
          add(const VerifyEmailSuccess());
        } else {
          add(VerifyEmailFailed(data as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(
          VerifyEmailStatus.Failed, ServerError.internalError());
    }
  }
}
