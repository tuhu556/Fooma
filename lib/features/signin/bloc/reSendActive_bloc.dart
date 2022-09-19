import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/features/signin/repository/reSendActive_repository.dart';
import 'package:foodhub/service/networking.dart';

part 'reSendActive_event.dart';
part 'reSendActive_state.dart';

class ReSendActiveBloc extends Bloc<ReSendActiveEvent, ReSendActiveState> {
  ReSendActiveBloc()
      : super(ReSendActiveState(status: ReSendActiveStatus.Initial));

  @override
  Stream<ReSendActiveState> mapEventToState(
    ReSendActiveEvent event,
  ) async* {
    // ignore: unnecessary_type_check
    if (event is CreateReSendActive) {
      yield state.copyWith(ReSendActiveStatus.Processing, null);
      yield* _mapReSendActiveToState(event);
    } else if (event is ReSendActiveSuccess) {
      yield state.copyWith(ReSendActiveStatus.Success, null);
    } else if (event is ReSendActiveFailed) {
      yield state.copyWith(ReSendActiveStatus.Failed, event.error);
    }
  }

  Stream<ReSendActiveState> _mapReSendActiveToState(
      CreateReSendActive event) async* {
    final repository = ReSendActiveRepository();

    try {
      repository.reSendActive(
        event.email,
        (data) {
          if (data is int && data == 200) {
            add(const ReSendActiveSuccess());
          } else {
            add(ReSendActiveFailed(data as ServerError));
          }
        },
      );
    } on Exception catch (_) {
      yield state.copyWith(
          ReSendActiveStatus.Failed, ServerError.internalError());
    }
  }
}
