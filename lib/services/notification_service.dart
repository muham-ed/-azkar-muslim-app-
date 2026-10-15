import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'prayer_service.dart';

/// جدولة إشعارات الصلاة لـ 7 أيام قدّام (نافذة متحركة).
/// كل تشغيل للتطبيق يعيد الجدولة. بعد reboot يعيدها
/// ScheduledNotificationBootReceiver (لازم يتضاف في AndroidManifest).
///
/// مهم: ثبّت flutter_local_notifications على ^18.0.1. من الإصدار 19 فصاعداً
/// تغيّرت توقيعات الدوال (title/body صارت named وحُذف uiLocalNotificationDateInterpretation)،
/// فلو رفعت الإصدار لازم تعدّل الاستدعاءات.
class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  // لو غيّرت الصوت لازم تغيّر الـ id (أندرويد لا يسمح بتعديل صوت قناة موجودة).
  static const _channelId = 'adhan_v1';
  static const _idBase = 0; // IDs من 0 إلى 99 مخصصة للأذان

  static AndroidFlutterLocalNotificationsPlugin? get _android =>
      _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  static Future<void> init() async {
    tzdata.initializeTimeZones();
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    await _plugin.initialize(settings);
  }

  /// يطلب إذن الإشعارات (أندرويد 13+) وإذن المنبهات الدقيقة (أندرويد 12+).
  /// يرجع true لو الجدولة الدقيقة مسموحة.
  static Future<bool> requestPermissions() async {
    await _android?.requestNotificationsPermission();
    var exact = await _android?.canScheduleExactNotifications() ?? false;
    if (!exact) {
      await _android?.requestExactAlarmsPermission();
      exact = await _android?.canScheduleExactNotifications() ?? false;
    }
    return exact;
  }

  static Future<void> scheduleAdhan({
    required double lat,
    required double lng,
    int days = 7,
    bool customSound = false, // true فقط لو أضفت android/app/src/main/res/raw/adhan.mp3
  }) async {
    // امسح جدولة الأذان القديمة فقط (لا نلمس إشعارات الأذكار).
    for (var i = _idBase; i < _idBase + 100; i++) {
      await _plugin.cancel(i);
    }

    final canExact = await _android?.canScheduleExactNotifications() ?? false;
    final mode = canExact
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle; // دقة أقل لكن لا يفشل

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        'مواقيت الصلاة',
        channelDescription: 'تنبيه عند دخول وقت الصلاة',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: customSound
            ? const RawResourceAndroidNotificationSound('adhan')
            : null,
        category: AndroidNotificationCategory.alarm,
      ),
    );

    final now = DateTime.now();
    for (var d = 0; d < days; d++) {
      final day = now.add(Duration(days: d));
      final list = PrayerService.forDay(lat, lng, day);
      for (var i = 0; i < list.length; i++) {
        final e = list[i];
        if (!e.time.isAfter(now)) continue;
        await _plugin.zonedSchedule(
          _idBase + d * 10 + i,
          'حان الآن موعد صلاة ${prayerArabic[e.name]}',
          'حيّ على الصلاة',
          // نمرّر اللحظة المطلقة بتوقيت UTC فلا نعتمد على ضبط منطقة زمنية محلية.
          tz.TZDateTime.from(e.time, tz.UTC),
          details,
          androidScheduleMode: mode,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      }
    }
  }

  /// للاختبار: إشعار بعد [seconds] ثانية. استخدمه لتجربة قفل الشاشة وإغلاق التطبيق.
  static Future<void> scheduleTest({int seconds = 120}) async {
    final canExact = await _android?.canScheduleExactNotifications() ?? false;
    await _plugin.zonedSchedule(
      99,
      'اختبار الأذان',
      'لو شفت الإشعار ده والتطبيق مقفول يبقى الجدولة شغالة',
      tz.TZDateTime.now(tz.UTC).add(Duration(seconds: seconds)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          'مواقيت الصلاة',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: canExact
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
