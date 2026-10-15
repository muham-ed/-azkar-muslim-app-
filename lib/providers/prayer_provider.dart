import 'dart:async';
import 'package:flutter/material.dart';

class PrayerItem {
  final String name;
  final String time;
  final DateTime dateTime;

  PrayerItem({
    required this.name,
    required this.time,
    required this.dateTime,
  });
}

class PrayerProvider with ChangeNotifier {
  Timer? _timer;
  Duration _timeUntilNext = Duration.zero;

  PrayerItem? _nextPrayer;
  List<PrayerItem> _todayPrayers = [];

  PrayerItem? get nextPrayer => _nextPrayer;
  List<PrayerItem> get todayPrayers => _todayPrayers;
  Duration get timeUntilNext => _timeUntilNext;

  PrayerProvider() {
    _calculatePrayerTimes();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateCountdown());
  }

  void _calculatePrayerTimes() {
    final now = DateTime.now();

    // مواقيت الصلاة الاسترشادية الثابتة حسب وقت اليوم
    final fajr = DateTime(now.year, now.month, now.day, 4, 45);
    final sunrise = DateTime(now.year, now.month, now.day, 6, 12);
    final dhuhr = DateTime(now.year, now.month, now.day, 12, 15);
    final asr = DateTime(now.year, now.month, now.day, 15, 30);
    final maghrib = DateTime(now.year, now.month, now.day, 18, 10);
    final isha = DateTime(now.year, now.month, now.day, 19, 30);

    _todayPrayers = [
      PrayerItem(name: 'الفجـر', time: '04:45 ص', dateTime: fajr),
      PrayerItem(name: 'الشروق', time: '06:12 ص', dateTime: sunrise),
      PrayerItem(name: 'الظـهر', time: '12:15 م', dateTime: dhuhr),
      PrayerItem(name: 'العصـر', time: '03:30 م', dateTime: asr),
      PrayerItem(name: 'المغرب', time: '06:10 م', dateTime: maghrib),
      PrayerItem(name: 'العشاء', time: '07:30 م', dateTime: isha),
    ];

    _updateCountdown();
  }

  void _updateCountdown() {
    final now = DateTime.now();

    PrayerItem? upcoming;
    for (var prayer in _todayPrayers) {
      if (prayer.dateTime.isAfter(now)) {
        upcoming = prayer;
        break;
      }
    }

    if (upcoming == null) {
      // إذا انتهت صلوات اليوم، فالصلاة القادمة هي الفجر للغد
      final tomorrowFajr = DateTime(now.year, now.month, now.day + 1, 4, 45);
      upcoming = PrayerItem(name: 'الفجـر', time: '04:45 ص', dateTime: tomorrowFajr);
    }

    _nextPrayer = upcoming;
    _timeUntilNext = upcoming.dateTime.difference(now);
    notifyListeners();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
