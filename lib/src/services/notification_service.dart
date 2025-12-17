import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService();
  final _local = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await _local.initialize(initSettings);
    await FirebaseMessaging.instance.requestPermission();
  }

  Future<void> showPartnerSetor({required String partnerName, required int nominal}) async {
    await _local.show(
      1,
      '$partnerName baru setor',
      'Nominal $nominal disimpan. Kita lanjut pelan-pelan.',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'partner',
          'Partner updates',
          channelDescription: 'Partner activity',
          importance: Importance.high,
        ),
      ),
    );
  }

  Future<void> scheduleReminderIfNeeded(TimeOfDay time) async {
    final now = TimeOfDay.now();
    if (time.hour >= 22) return;
    if (now.hour > time.hour) return; // skip if already late
    await _local.zonedSchedule(
      2,
      'Setor kecil aja',
      'Hari ini mau setor bareng? +7K cukup.',
      _nextInstanceOf(time),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'reminder',
          'Daily Reminder',
          channelDescription: 'Halus, tanpa maksa',
          importance: Importance.defaultImportance,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime _nextInstanceOf(TimeOfDay time) {
    final now = DateTime.now();
    var scheduled = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return tz.TZDateTime.from(scheduled, tz.local);
  }
}
