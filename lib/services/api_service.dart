import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // Aladhan API for accurate prayer times worldwide
  static Future<Map<String, String>?> fetchPrayerTimes({
    String city = 'Cairo',
    String country = 'Egypt',
  }) async {
    try {
      final url = Uri.parse(
        'https://api.aladhan.com/v1/timingsByCity?city=$city&country=$country&method=5',
      );
      final response = await http.get(url).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final timings = data['data']['timings'];
        return {
          'Fajr': timings['Fajr'],
          'Sunrise': timings['Sunrise'],
          'Dhuhr': timings['Dhuhr'],
          'Asr': timings['Asr'],
          'Maghrib': timings['Maghrib'],
          'Isha': timings['Isha'],
        };
      }
    } catch (e) {
      debugPrint('Error fetching live prayer times from API: $e');
    }
    return null;
  }
}
