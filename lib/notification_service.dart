import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// Initialize the FlutterLocalNotificationsPlugin instance
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

// Initialize notifications and create notification channel (Android)
Future<void> _initializeNotifications() async {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'reminder_channel_id', // ID for the channel
    'Reminder Channel', // Name for the channel
    description: 'Channel for reminder notifications',
    importance: Importance.high, // Important notifications
    playSound: true, // Enable sound
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

// Schedule a notification
Future<void> scheduleNotification(DateTime scheduledDateTime, String activity) async {
  // Ensure time zones are initialized
  tz.initializeTimeZones();
  
  // Define the time zone location (Asia/Kolkata for IST)
  final ist = tz.getLocation('Asia/Kolkata');
  
  // Convert local DateTime to TZDateTime
  final tzDateTime = tz.TZDateTime.from(scheduledDateTime, ist);

  // Print for debugging
  print('Scheduling notification for $tzDateTime');

  // Schedule the notification
  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'Reminder',
    activity,
    tzDateTime,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'reminder_channel_id',
        'Reminder Channel',
        channelDescription: 'Channel for reminder notifications',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('song'), // Android sound file name without extension
      ),
      iOS: DarwinNotificationDetails(
        sound: 'song.mp3', // iOS sound file name with extension
      ),
    ),
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}
