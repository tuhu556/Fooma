import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:equatable/equatable.dart';
import 'package:foodhub/features/signup/repository/signup_repository.dart';
import 'package:foodhub/service/networking.dart';
part 'signup_event.dart';
part 'signup_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpState(status: SignUpStatus.Initial));
  @override
  Stream<SignUpState> mapEventToState(
    SignUpEvent event,
  ) async* {
    if (event is CreateSignUpEvent) {
      yield state.copyWith(SignUpStatus.Processing, null);
      yield* _mapSignupState(event);
    } else if (event is CreateSignUpSuccess) {
      yield state.copyWith(SignUpStatus.Success, null);
    } else if (event is CreateSignUpDulicated) {
      yield state.copyWith(SignUpStatus.Duplicated, null);
    } else if (event is CreateSignUpFailed) {
      yield state.copyWith(SignUpStatus.Failed, event.error);
    }
  }

  Stream<SignUpState> _mapSignupState(CreateSignUpEvent event) async* {
    final repository = SignupRestRepository();
    final params = state.createSignUpParameters;
    params["email"] = event.email;
    params["name"] = event.name;
    params["password"] = event.password;

    print(params);

    try {
      repository.createSigup(params, (data) {
        if (data is int && (data == 200)) {
          add(const CreateSignUpSuccess());
        } else if (data is int && (data == 410)) {
          add(const CreateSignUpDulicated());
        } else {
          add(CreateSignUpFailed(data as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(SignUpStatus.Failed, ServerError.internalError());
    }
  }
}
