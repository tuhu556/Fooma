part of 'notification_bloc.dart';

@immutable
class AllNotiEvent extends Equatable {
  const AllNotiEvent();

  @override
  List<Object> get props => [];
}

class AllNotification extends AllNotiEvent {
  const AllNotification();
}

class GetAllNotificationSuccess extends AllNotiEvent {
  final NotificationResponse allNotification;
  const GetAllNotificationSuccess(this.allNotification);
}

class GetAllNotificationFailed extends AllNotiEvent {
  final ServerError error;
  const GetAllNotificationFailed(this.error);
}

class AllNotiSocial extends AllNotiEvent {
  final int page;
  const AllNotiSocial(this.page);
}

class GetAllNotiSocialSuccess extends AllNotiEvent {
  final NotificationResponse allNotiSocial;
  const GetAllNotiSocialSuccess(this.allNotiSocial);
}

class GetAllNotiSocialFailed extends AllNotiEvent {
  final ServerError error;
  const GetAllNotiSocialFailed(this.error);
}

class AllNotiIngredient extends AllNotiEvent {
  final int page;
  const AllNotiIngredient(this.page);
}

class GetAllNotiIngredientSuccess extends AllNotiEvent {
  final NotificationResponse allNotiIngredient;
  const GetAllNotiIngredientSuccess(this.allNotiIngredient);
}

class GetAllNotiIngredientFailed extends AllNotiEvent {
  final ServerError error;
  const GetAllNotiIngredientFailed(this.error);
}

class AllNotiPlan extends AllNotiEvent {
  final int page;
  const AllNotiPlan(this.page);
}

class GetAllNotiPlanSuccess extends AllNotiEvent {
  final NotificationResponse allNotiPlan;
  const GetAllNotiPlanSuccess(this.allNotiPlan);
}

class GetAllNotiPlanFailed extends AllNotiEvent {
  final ServerError error;
  const GetAllNotiPlanFailed(this.error);
}

class ReadNoti extends AllNotiEvent {
  String id;
  ReadNoti({
    required this.id,
  });
}

class ReadNotiSuccess extends AllNotiEvent {
  const ReadNotiSuccess();
}

class ReadNotiFailed extends AllNotiEvent {
  final ServerError error;
  const ReadNotiFailed(this.error);
}
