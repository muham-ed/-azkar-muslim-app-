import 'dart:async';
import 'package:adhan/adhan.dart';
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
  final String _selectedCity = 'القاهرة (حساب محلي دقيق)';

  PrayerItem? get nextPrayer => _nextPrayer;
  List<PrayerItem> get todayPrayers => _todayPrayers;
  Duration get timeUntilNext => _timeUntilNext;
  String get selectedCity => _selectedCity;

  PrayerProvider() {
    _calculateOfflinePrayerTimes();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateCountdown());
  }

  void _calculateOfflinePrayerTimes() {
    // إحداثيات القاهرة - هيئة المساحة المصرية (حساب أوفلاين دقيق 100%)
    final coordinates = Coordinates(30.0444, 31.2357);
    final params = CalculationMethod.egyptian.getParameters();
    params.madhab = Madhab.shafi;

    final prayerTimes = PrayerTimes.today(coordinates, params);

    String format12h(DateTime dt) {
      final local = dt.toLocal();
      final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
      final ampm = local.hour >= 12 ? 'م' : 'ص';
      final minute = local.minute.toString().padLeft(2, '0');
      return '${hour.toString().padLeft(2, '0')}:$minute $ampm';
    }

    _todayPrayers = [
      PrayerItem(name: 'الفجـر', time: format12h(prayerTimes.fajr), dateTime: prayerTimes.fajr.toLocal()),
      PrayerItem(name: 'الشروق', time: format12h(prayerTimes.sunrise), dateTime: prayerTimes.sunrise.toLocal()),
      PrayerItem(name: 'الظـهر', time: format12h(prayerTimes.dhuhr), dateTime: prayerTimes.dhuhr.toLocal()),
      PrayerItem(name: 'العصـر', time: format12h(prayerTimes.asr), dateTime: prayerTimes.asr.toLocal()),
      PrayerItem(name: 'المغرب', time: format12h(prayerTimes.maghrib), dateTime: prayerTimes.maghrib.toLocal()),
      PrayerItem(name: 'العشاء', time: format12h(prayerTimes.isha), dateTime: prayerTimes.isha.toLocal()),
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
      final coordinates = Coordinates(30.0444, 31.2357);
      final params = CalculationMethod.egyptian.getParameters();
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final tomorrowDateComponents = DateComponents.from(tomorrow);
      final tomorrowPrayers = PrayerTimes(coordinates, tomorrowDateComponents, params);

      String format12h(DateTime dt) {
        final local = dt.toLocal();
        final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
        final ampm = local.hour >= 12 ? 'م' : 'ص';
        final minute = local.minute.toString().padLeft(2, '0');
        return '${hour.toString().padLeft(2, '0')}:$minute $ampm';
      }

      upcoming = PrayerItem(
        name: 'الفجـر',
        time: format12h(tomorrowPrayers.fajr),
        dateTime: tomorrowPrayers.fajr.toLocal(),
      );
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
