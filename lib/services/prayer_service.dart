import 'package:adhan_dart/adhan_dart.dart';

enum PrayerName { fajr, dhuhr, asr, maghrib, isha }

const Map<PrayerName, String> prayerArabic = {
  PrayerName.fajr: 'الفجر',
  PrayerName.dhuhr: 'الظهر',
  PrayerName.asr: 'العصر',
  PrayerName.maghrib: 'المغرب',
  PrayerName.isha: 'العشاء',
};

class PrayerEntry {
  final PrayerName name;
  final DateTime time; // بتوقيت الجهاز المحلي
  const PrayerEntry(this.name, this.time);
}

/// حساب مواقيت الصلاة محلياً 100% (لا إنترنت).
/// الطريقة: الهيئة المصرية العامة للمساحة. قارن النتيجة بجدول رسمي لمدينتك
/// وعدّل params.adjustments لو لقيت فرق دقائق.
class PrayerService {
  static CalculationParameters _params() =>
      CalculationMethodParameters.egyptian();

  static List<PrayerEntry> forDay(double lat, double lng, DateTime day) {
    final pt = PrayerTimes(
      coordinates: Coordinates(lat, lng),
      date: DateTime(day.year, day.month, day.day),
      calculationParameters: _params(),
      precision: true,
    );
    return [
      PrayerEntry(PrayerName.fajr, pt.fajr.toLocal()),
      PrayerEntry(PrayerName.dhuhr, pt.dhuhr.toLocal()),
      PrayerEntry(PrayerName.asr, pt.asr.toLocal()),
      PrayerEntry(PrayerName.maghrib, pt.maghrib.toLocal()),
      PrayerEntry(PrayerName.isha, pt.isha.toLocal()),
    ];
  }

  /// الصلاة القادمة (تنتقل لفجر الغد بعد العشاء).
  static PrayerEntry next(double lat, double lng, {DateTime? now}) {
    final t = now ?? DateTime.now();
    for (final e in forDay(lat, lng, t)) {
      if (e.time.isAfter(t)) return e;
    }
    return forDay(lat, lng, t.add(const Duration(days: 1))).first;
  }
}
