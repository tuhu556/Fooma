import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/features/signin/repository/activeCode_repository.dart';
import 'package:foodhub/service/networking.dart';
import 'package:foodhub/session/session.dart';

import '../models/signin_entity.dart';
part 'activeCode_event.dart';
part 'activeCode_state.dart';

class ActiveCodeBloc extends Bloc<ActiveCodeEvent, ActiveCodeState> {
  ActiveCodeBloc() : super(ActiveCodeState(status: ActiveCodeStatus.Initial));

  @override
  Stream<ActiveCodeState> mapEventToState(
    ActiveCodeEvent event,
  ) async* {
    // ignore: unnecessary_type_check
    if (event is ActiveCode) {
      yield state.copyWith(ActiveCodeStatus.Processing, null, null);
      yield* _mapActiveCodeToState(event);
    } else if (event is ActiveCodeSuccess) {
      yield state.copyWith(ActiveCodeStatus.Success, event.data, null);
    } else if (event is ActiveCodeFailed) {
      yield state.copyWith(ActiveCodeStatus.Failed, null, event.error);
    }
  }

  Stream<ActiveCodeState> _mapActiveCodeToState(ActiveCode event) async* {
    final repository = ActiveCodeRestRepository();

    try {
      repository.activeCode(
        event.email,
        event.activeCode,
        (data) {
          if (data is AuthenticationCredential) {
            add(ActiveCodeSuccess(data));
          } else {
            add(ActiveCodeFailed(data as ServerError));
          }
        },
      );
    } on Exception catch (_) {
      yield state.copyWith(
          ActiveCodeStatus.Failed, null, ServerError.internalError());
    }
  }
}
