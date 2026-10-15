import 'dart:math' as math;

/// إحداثيات الكعبة المشرفة.
const double kKaabaLat = 21.4225;
const double kKaabaLng = 39.8262;

/// زاوية القبلة (0..360) من الشمال الحقيقي باتجاه عقارب الساعة
/// (great-circle initial bearing). دالة نقية قابلة للاختبار.
double qiblaBearing(double lat, double lng) {
  final p1 = lat * math.pi / 180;
  final p2 = kKaabaLat * math.pi / 180;
  final dl = (kKaabaLng - lng) * math.pi / 180;
  final y = math.sin(dl) * math.cos(p2);
  final x = math.cos(p1) * math.sin(p2) -
      math.sin(p1) * math.cos(p2) * math.cos(dl);
  final deg = math.atan2(y, x) * 180 / math.pi;
  return (deg + 360) % 360;
}
