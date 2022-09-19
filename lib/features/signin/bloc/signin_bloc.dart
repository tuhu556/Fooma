import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/features/signin/models/signin_entity.dart';
import 'package:foodhub/service/networking.dart';

import '../repository/signin_repository.dart';

part 'signin_event.dart';

part 'signin_state.dart';

class SigninBloc extends Bloc<SignInEvent, SignInState> {
  SigninBloc() : super(SignInState(status: SignInStatus.Initial));

  @override
  Stream<SignInState> mapEventToState(
    SignInEvent event,
  ) async* {
    if (event is SignIn) {
      yield state.copyWith(SignInStatus.Processing, null, null);
      yield* _mapSignInToState(event);
    } else if (event is SignInSuccess) {
      yield state.copyWith(SignInStatus.Success, event.data, null);
    } else if (event is SignInNotActive) {
      yield state.copyWith(SignInStatus.NotActive, null, null);
    } else if (event is SignInBan) {
      yield state.copyWith(SignInStatus.Ban, null, null);
    } else if (event is SignInFailed) {
      yield state.copyWith(SignInStatus.Failed, null, event.error);
    } else if (event is SignInWithGoogle) {
      yield state.copyWith(SignInStatus.WithGoogleProcessing, null, null);
      yield* _mapSignInWithGoogleToState(event);
    } else if (event is SignInWithGoogleSuccess) {
      yield state.copyWith(SignInStatus.WithGoogleSuccess, event.data, null);
    } else if (event is SignInWithGoogleFailed) {
      yield state.copyWith(SignInStatus.WithGoogleFailed, null, event.error);
    }
  }

  Stream<SignInState> _mapSignInToState(SignIn event) async* {
    final repository = SignInRestRepository();

    try {
      repository.signIn(
        event.email,
        event.password,
        event.deviceId,
        (data) {
          if (data is AuthenticationCredential) {
            add(SignInSuccess(data));
          } else if (data is int && (data == 210)) {
            add(const SignInNotActive());
          } else if (data is int && (data == 1412)) {
            add(const SignInBan());
          } else {
            add(SignInFailed(data as ServerError));
          }
        },
      );
    } on Exception catch (_) {
      yield state.copyWith(
          SignInStatus.Failed, null, ServerError.internalError());
    }
  }

  Stream<SignInState> _mapSignInWithGoogleToState(
      SignInWithGoogle event) async* {
    final repository = SignInRestRepository();

    try {
      repository.signInWithGoogle(
        event.token,
        event.deviceId,
        (data) {
          if (data is AuthenticationCredential) {
            add(SignInWithGoogleSuccess(data));
          } else {
            add(SignInWithGoogleFailed(data as ServerError));
          }
        },
      );
    } on Exception catch (_) {
      yield state.copyWith(
          SignInStatus.WithGoogleFailed, null, ServerError.internalError());
    }
  }
}
