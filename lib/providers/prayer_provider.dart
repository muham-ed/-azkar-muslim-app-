import 'dart:async';
import 'package:flutter/material.dart';
import '../services/api_service.dart';

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
  String _selectedCity = 'القاهرة (مصر)';
  bool _isLoadingApi = false;

  PrayerItem? get nextPrayer => _nextPrayer;
  List<PrayerItem> get todayPrayers => _todayPrayers;
  Duration get timeUntilNext => _timeUntilNext;
  String get selectedCity => _selectedCity;
  bool get isLoadingApi => _isLoadingApi;

  PrayerProvider() {
    _initPrayerTimes();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateCountdown());
  }

  void _initPrayerTimes() async {
    _calculateLocalTimes(); // التوقيت المحلي الافتراضي فوراً
    await fetchLivePrayerTimes('Cairo', 'Egypt');
  }

  Future<void> fetchLivePrayerTimes(String city, String country) async {
    _isLoadingApi = true;
    notifyListeners();

    final liveTimings = await ApiService.fetchPrayerTimes(city: city, country: country);

    if (liveTimings != null) {
      final now = DateTime.now();

      DateTime parseTime(String timeStr) {
        final parts = timeStr.split(':');
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1].split(' ')[0]);
        return DateTime(now.year, now.month, now.day, hour, minute);
      }

      String format12h(DateTime dt) {
        final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
        final ampm = dt.hour >= 12 ? 'م' : 'ص';
        final minute = dt.minute.toString().padLeft(2, '0');
        return '${hour.toString().padLeft(2, '0')}:$minute $ampm';
      }

      final fajrDt = parseTime(liveTimings['Fajr']!);
      final sunriseDt = parseTime(liveTimings['Sunrise']!);
      final dhuhrDt = parseTime(liveTimings['Dhuhr']!);
      final asrDt = parseTime(liveTimings['Asr']!);
      final maghribDt = parseTime(liveTimings['Maghrib']!);
      final ishaDt = parseTime(liveTimings['Isha']!);

      _todayPrayers = [
        PrayerItem(name: 'الفجـر', time: format12h(fajrDt), dateTime: fajrDt),
        PrayerItem(name: 'الشروق', time: format12h(sunriseDt), dateTime: sunriseDt),
        PrayerItem(name: 'الظـهر', time: format12h(dhuhrDt), dateTime: dhuhrDt),
        PrayerItem(name: 'العصـر', time: format12h(asrDt), dateTime: asrDt),
        PrayerItem(name: 'المغرب', time: format12h(maghribDt), dateTime: maghribDt),
        PrayerItem(name: 'العشاء', time: format12h(ishaDt), dateTime: ishaDt),
      ];
    }

    _isLoadingApi = false;
    _updateCountdown();
  }

  void _calculateLocalTimes() {
    final now = DateTime.now();

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
