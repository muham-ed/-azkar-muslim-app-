import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLocation {
  final double lat;
  final double lng;
  final bool isFallback; // true = لم نحصل على GPS ونستخدم قيمة احتياطية
  const AppLocation(this.lat, this.lng, {this.isFallback = false});
}

class LocationService {
  // احتياطي: الإسكندرية. الأفضل تخلي المستخدم يختار مدينة.
  static const _fallback = AppLocation(31.2001, 29.9187, isFallback: true);

  static Future<AppLocation> get() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return _cached(prefs);
      }
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        return _cached(prefs);
      }
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low, // يكفي للمواقيت ويوفر البطارية
          timeLimit: Duration(seconds: 15),
        ),
      );
      await prefs.setDouble('lat', pos.latitude);
      await prefs.setDouble('lng', pos.longitude);
      return AppLocation(pos.latitude, pos.longitude);
    } catch (_) {
      return _cached(prefs);
    }
  }

  static AppLocation _cached(SharedPreferences p) {
    final lat = p.getDouble('lat');
    final lng = p.getDouble('lng');
    if (lat != null && lng != null) return AppLocation(lat, lng);
    return _fallback;
  }
}
