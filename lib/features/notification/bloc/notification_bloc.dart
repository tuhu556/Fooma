import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';

import 'package:flutter/material.dart';
import 'package:foodhub/features/notification/repository/notification_repository.dart';

import '../../../service/networking.dart';
import '../models/notification.dart';
part 'notification_event.dart';

part 'notification_state.dart';

class AllNotiBloc extends Bloc<AllNotiEvent, AllNotiState> {
  AllNotiBloc() : super(AllNotiState(status: AllNotiStatus.Initial));

  @override
  Stream<AllNotiState> mapEventToState(
    AllNotiEvent event,
  ) async* {
    if (event is AllNotiSocial) {
      yield state.copyWith(
          AllNotiStatus.Processing, null, null, null, null, null);
      yield* _mapGetMyNotiSocialToState(event);
    } else if (event is GetAllNotiSocialSuccess) {
      yield state.copyWith(
          AllNotiStatus.Success, event.allNotiSocial, null, null, null, null);
    } else if (event is GetAllNotiSocialFailed) {
      yield state.copyWith(
          AllNotiStatus.Failed, null, null, null, null, event.error);
    }
    //!
    else if (event is AllNotiIngredient) {
      yield state.copyWith(
          AllNotiStatus.IngredientProcessing, null, null, null, null, null);
      yield* _mapGetMyNotiIngredientToState(event);
    } else if (event is GetAllNotiIngredientSuccess) {
      yield state.copyWith(AllNotiStatus.IngredientSuccess, null,
          event.allNotiIngredient, null, null, null);
    } else if (event is GetAllNotiIngredientFailed) {
      yield state.copyWith(
          AllNotiStatus.IngredientFailed, null, null, null, null, event.error);
    }
    //!
    else if (event is AllNotiPlan) {
      yield state.copyWith(
          AllNotiStatus.PlanProcessing, null, null, null, null, null);
      yield* _mapGetMyNotiPlanToState(event);
    } else if (event is GetAllNotiPlanSuccess) {
      yield state.copyWith(
          AllNotiStatus.PlanSuccess, null, null, event.allNotiPlan, null, null);
    } else if (event is GetAllNotiPlanFailed) {
      yield state.copyWith(
          AllNotiStatus.PlanFailed, null, null, null, null, event.error);
    }
    //!
    else if (event is ReadNoti) {
      yield state.copyWith(
          AllNotiStatus.ReadProcessing, null, null, null, null, null);
      yield* _mapReadNotiToState(event);
    } else if (event is ReadNotiSuccess) {
      yield state.copyWith(
          AllNotiStatus.ReadSuccess, null, null, null, null, null);
    } else if (event is ReadNotiFailed) {
      yield state.copyWith(
          AllNotiStatus.ReadFailed, null, null, null, null, event.error);
    }
    //!
    else if (event is AllNotification) {
      yield state.copyWith(
          AllNotiStatus.AllProcessing, null, null, null, null, null);
      yield* _mapGetMyNotificationToState(event);
    } else if (event is GetAllNotificationSuccess) {
      yield state.copyWith(AllNotiStatus.AllSuccess, null, null, null,
          event.allNotification, null);
    } else if (event is GetAllNotificationFailed) {
      yield state.copyWith(
          AllNotiStatus.AllFailed, null, null, null, null, event.error);
    }
  }

  Stream<AllNotiState> _mapGetMyNotificationToState(
      AllNotification event) async* {
    final repository = AllNotiRestRepository();

    try {
      repository.getAllNotification((value) {
        if (value is NotificationResponse) {
          add(GetAllNotificationSuccess(value));
        } else {
          add(GetAllNotificationFailed(value as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(AllNotiStatus.AllFailed, null, null, null, null,
          ServerError.internalError());
    }
  }

  Stream<AllNotiState> _mapGetMyNotiSocialToState(AllNotiSocial event) async* {
    final repository = AllNotiRestRepository();

    try {
      repository.getAllNotiSocial(event.page, (value) {
        if (value is NotificationResponse) {
          add(GetAllNotiSocialSuccess(value));
        } else {
          add(GetAllNotiSocialFailed(value as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(AllNotiStatus.Failed, null, null, null, null,
          ServerError.internalError());
    }
  }

  Stream<AllNotiState> _mapGetMyNotiIngredientToState(
      AllNotiIngredient event) async* {
    final repository = AllNotiRestRepository();

    try {
      repository.getAllNotiIngredient(event.page, (value) {
        if (value is NotificationResponse) {
          add(GetAllNotiIngredientSuccess(value));
        } else {
          add(GetAllNotiIngredientFailed(value as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(AllNotiStatus.Failed, null, null, null, null,
          ServerError.internalError());
    }
  }

  Stream<AllNotiState> _mapGetMyNotiPlanToState(AllNotiPlan event) async* {
    final repository = AllNotiRestRepository();

    try {
      repository.getAllNotiPlan(event.page, (value) {
        if (value is NotificationResponse) {
          add(GetAllNotiPlanSuccess(value));
        } else {
          add(GetAllNotiPlanFailed(value as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(AllNotiStatus.Failed, null, null, null, null,
          ServerError.internalError());
    }
  }

  Stream<AllNotiState> _mapReadNotiToState(ReadNoti event) async* {
    final repository = AllNotiRestRepository();

    try {
      repository.markAsReadNoti(event.id, (data) {
        if (data is int && data == 200 || data == 204) {
          add(const ReadNotiSuccess());
        } else {
          add(ReadNotiFailed(data as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(AllNotiStatus.ReadFailed, null, null, null, null,
          ServerError.internalError());
    }
  }
}
