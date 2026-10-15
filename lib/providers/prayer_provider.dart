import 'dart:async';
import 'package:flutter/material.dart';
import '../services/prayer_service.dart';

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
  final String _selectedCity = 'القاهرة (حساب محلي دقيق 100%)';

  PrayerItem? get nextPrayer => _nextPrayer;
  List<PrayerItem> get todayPrayers => _todayPrayers;
  Duration get timeUntilNext => _timeUntilNext;
  String get selectedCity => _selectedCity;

  PrayerProvider() {
    _calculateOfflinePrayerTimes();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateCountdown());
  }

  void _calculateOfflinePrayerTimes() {
    // إحداثيات القاهرة كمثال افتراضي
    const double lat = 30.0444;
    const double lng = 31.2357;

    final entries = PrayerService.forDay(lat, lng, DateTime.now());

    String format12h(DateTime dt) {
      final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final ampm = dt.hour >= 12 ? 'م' : 'ص';
      final minute = dt.minute.toString().padLeft(2, '0');
      return '${hour.toString().padLeft(2, '0')}:$minute $ampm';
    }

    _todayPrayers = entries.map((e) {
      return PrayerItem(
        name: prayerArabic[e.name] ?? '',
        time: format12h(e.time),
        dateTime: e.time,
      );
    }).toList();

    _updateCountdown();
  }

  void _updateCountdown() {
    final now = DateTime.now();
    const double lat = 30.0444;
    const double lng = 31.2357;

    final nextEntry = PrayerService.next(lat, lng, now: now);

    String format12h(DateTime dt) {
      final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final ampm = dt.hour >= 12 ? 'م' : 'ص';
      final minute = dt.minute.toString().padLeft(2, '0');
      return '${hour.toString().padLeft(2, '0')}:$minute $ampm';
    }

    _nextPrayer = PrayerItem(
      name: prayerArabic[nextEntry.name] ?? '',
      time: format12h(nextEntry.time),
      dateTime: nextEntry.time,
    );

    _timeUntilNext = nextEntry.time.difference(now);
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
