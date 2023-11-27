import 'dart:developer' as developer;
import 'dart:math';
import 'package:restaurant_app/common/navigation.dart';
import 'package:restaurant_app/data/model/list_restaurant.dart';
import 'package:rxdart/subjects.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  static NotificationHelper? _instance;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');

    var initializationSettingsIOS = const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        String? payload = response.payload;
        if (payload != null) {
          developer.log('notification payload: $payload');
        }
        selectNotificationSubject.add(payload ?? 'empty payload');
      },
    );
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      Restaurant restaurant) async {
    var channelId = "1";
    var channelName = "Recommended Restaurant";
    var channelDescription = "Recommended Restaurant";

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        channelId, channelName,
        channelDescription: channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        styleInformation: const DefaultStyleInformation(true, true));

    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    var randomIndex = Random().nextInt(restaurant.restaurants.length);

    var titleNotification = "<b>Today's Recommendation</b>";
    var titleRestaurant = restaurant.restaurants[randomIndex].name;

    await flutterLocalNotificationsPlugin.show(
        0, titleNotification, titleRestaurant, platformChannelSpecifics,
        payload: restaurant.restaurants[randomIndex].id);
  }

  void configureSelectNotificationSubject(String route) {
    selectNotificationSubject.stream.listen(
      (String payload) async {
        Navigation.intentWithData(route, payload);
      },
    );
  }
}
