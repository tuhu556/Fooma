part of 'notification_bloc.dart';

@immutable
class AllNotiState extends Equatable {
  final AllNotiStatus status;

  NotificationResponse? allNotiSocial;
  NotificationResponse? allNotiIngredient;
  NotificationResponse? allNotiPlan;
  NotificationResponse? allNotification;
  ServerError? error;

  AllNotiState({required this.status});

  List<Object> get props => [status];

  AllNotiState copyWith(
      AllNotiStatus? status,
      NotificationResponse? allNotiSocial,
      NotificationResponse? allNotiIngredient,
      NotificationResponse? allNotiPlan,
      NotificationResponse? allNotification,
      ServerError? error) {
    var newState = AllNotiState(status: status ?? this.status);

    if (allNotiSocial != null) {
      newState.allNotiSocial = allNotiSocial;
    }
    if (allNotiIngredient != null) {
      newState.allNotiIngredient = allNotiIngredient;
    }
    if (allNotiPlan != null) {
      newState.allNotiPlan = allNotiPlan;
    }

    if (allNotification != null) {
      newState.allNotification = allNotification;
    }

    if (error != null) {
      newState.error = error;
    }

    return newState;
  }
}

enum AllNotiStatus {
  Initial,
  Processing,
  Success,
  Failed,
  AllInitial,
  AllProcessing,
  AllSuccess,
  AllFailed,
  IngredientInitial,
  IngredientProcessing,
  IngredientSuccess,
  IngredientFailed,
  PlanInitial,
  PlanProcessing,
  PlanSuccess,
  PlanFailed,
  ReadInitial,
  ReadProcessing,
  ReadSuccess,
  ReadFailed,
}
