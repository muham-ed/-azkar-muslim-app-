import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';

import '../utils/qibla.dart';

class QiblaScreen extends StatelessWidget {
  final double lat;
  final double lng;
  const QiblaScreen({super.key, required this.lat, required this.lng});

  @override
  Widget build(BuildContext context) {
    final qibla = qiblaBearing(lat, lng);
    final stream = FlutterCompass.events; // null لو الجهاز بلا حساس
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('اتجاه القبلة')),
        body: Center(
          child: stream == null
              ? const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('جهازك لا يحتوي على حساس بوصلة.',
                      textAlign: TextAlign.center),
                )
              : StreamBuilder<CompassEvent>(
                  stream: stream,
                  builder: (context, snap) {
                    if (snap.hasError) {
                      return const Text('تعذّر قراءة حساس البوصلة');
                    }
                    final heading = snap.data?.heading; // درجات من الشمال
                    if (heading == null) {
                      return const CircularProgressIndicator();
                    }
                    // السهم يدور بمقدار (زاوية القبلة − اتجاه الهاتف)
                    final diff = ((qibla - heading) + 540) % 360 - 180;
                    final aligned = diff.abs() < 3;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Transform.rotate(
                          angle: diff * math.pi / 180,
                          child: Icon(
                            Icons.navigation,
                            size: 180,
                            color: aligned
                                ? Colors.green
                                : Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(aligned
                            ? 'أنت في اتجاه القبلة'
                            : 'أدر الهاتف حتى يشير السهم للأعلى'),
                        const SizedBox(height: 8),
                        Text('زاوية القبلة: ${qibla.toStringAsFixed(1)}°'),
                        const SizedBox(height: 8),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            'ابعد عن المعادن والمغناطيس. لو الاتجاه غير منطقي حرّك الهاتف على شكل ∞ لمعايرة الحساس.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    );
                  },
                ),
        ),
      ),
    );
  }
}
