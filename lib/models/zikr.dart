import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Zikr {
  final String id;
  final String text;
  final int count;
  final List<String> times; // morning / evening
  final String source; // الكتاب
  final String? virtue;
  final bool reviewed; // false = لم يُراجَع بعد من مصدر موثوق
  final String? note;

  const Zikr({
    required this.id,
    required this.text,
    required this.count,
    required this.times,
    required this.source,
    this.virtue,
    required this.reviewed,
    this.note,
  });

  factory Zikr.fromJson(Map<String, dynamic> j) => Zikr(
        id: j['id'] as String,
        text: j['text'] as String,
        count: j['count'] as int,
        times: List<String>.from(j['times'] as List),
        source: j['source'] as String,
        virtue: j['virtue'] as String?,
        reviewed: j['reviewed'] as bool,
        note: j['note'] as String?,
      );

  static Future<List<Zikr>> loadAll() async {
    final raw = await rootBundle.loadString('assets/data/azkar.json');
    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    return list.map(Zikr.fromJson).toList();
  }
}
