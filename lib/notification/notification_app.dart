// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:flutter/material.dart';

// import 'models/notification_ingredient_entity.dart';

// Future<void> createIngredientNotification(
//     NotificationIngredient notificationIngredient) async {
//   await AwesomeNotifications().createNotification(
//     content: NotificationContent(
//       id: DateTime.now().millisecondsSinceEpoch.remainder(100005),
//       channelKey: 'basic_channel',
//       title: notificationIngredient.title,
//       body: notificationIngredient.body,
//       notificationLayout: NotificationLayout.Default,
//     ),
//   );
// }

// Future<void> createIngredientReminderNotification(
//     NotificationIngredient notificationIngredient) async {
//   await AwesomeNotifications().createNotification(
//     content: NotificationContent(
//       id: notificationIngredient.notificationId,
//       channelKey: 'scheduled_channel',
//       title: notificationIngredient.title,
//       body: notificationIngredient.body,
//       notificationLayout: NotificationLayout.Default,
//     ),
//     // actionButtons: [
//     //   NotificationActionButton(key: 'MARK_DONE', label: 'Mark Done'),
//     // ],
//     schedule: NotificationCalendar(
//         day: notificationIngredient.day,
//         hour: 6,
//         minute: 0,
//         second: 0,
//         millisecond: 0,
//         repeats: false),
//   );

//   await AwesomeNotifications().createNotification(
//     content: NotificationContent(
//       id: notificationIngredient.notificationId + 1,
//       channelKey: 'scheduled_channel',
//       title: notificationIngredient.title,
//       body: notificationIngredient.body,
//       notificationLayout: NotificationLayout.Default,
//     ),
//     // actionButtons: [
//     //   NotificationActionButton(key: 'MARK_DONE', label: 'Mark Done'),
//     // ],
//     schedule: NotificationCalendar(
//         day: notificationIngredient.day,
//         hour: 12,
//         minute: 0,
//         second: 0,
//         millisecond: 0,
//         repeats: false),
//   );

//   await AwesomeNotifications().createNotification(
//     content: NotificationContent(
//       id: notificationIngredient.notificationId + 2,
//       channelKey: 'scheduled_channel',
//       title: notificationIngredient.title,
//       body: notificationIngredient.body,
//       notificationLayout: NotificationLayout.Default,
//     ),
//     // actionButtons: [
//     //   NotificationActionButton(key: 'MARK_DONE', label: 'Mark Done'),
//     // ],
//     schedule: NotificationCalendar(
//         day: notificationIngredient.day,
//         hour: 17,
//         minute: 0,
//         second: 0,
//         millisecond: 0,
//         repeats: false),
//   );
// }

// Future<void> cancelAllScheduleNotification() async {
//   await AwesomeNotifications().cancelAllSchedules();
// }

// Future<void> cancelScheduleNotification(int notificationId) async {
//   await AwesomeNotifications().cancelSchedule(notificationId);
//   print("Delete notidId: " + notificationId.toString());
// }
