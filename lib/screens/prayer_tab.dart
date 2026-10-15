import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:provider/provider.dart';
import '../providers/prayer_provider.dart';
import '../theme/app_theme.dart';

class PrayerTab extends StatelessWidget {
  const PrayerTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Live Compass Widget with FlutterCompass
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.accentGold.withOpacity(0.4)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.explore, color: AppColors.accentGold, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'بوصلة اتجاه القبلة المباشرة',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                StreamBuilder<CompassEvent>(
                  stream: FlutterCompass.events,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('خطأ في حاساس البوصلة للجهاز');
                    }

                    double? heading = snapshot.data?.heading;

                    // إن لم تتوفر البوصلة نستخدم زاوية ثابتة افتراضية لاتجاه القبلة من القاهرة (136 درجة)
                    double qiblaHeading = heading != null ? (136 - heading) : 136;

                    return Column(
                      children: [
                        Transform.rotate(
                          angle: (qiblaHeading * (math.pi / 180)),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primaryGreen.withOpacity(0.08),
                                  border: Border.all(color: AppColors.primaryGreen, width: 2),
                                ),
                              ),
                              const Icon(
                                Icons.navigation,
                                size: 54,
                                color: AppColors.primaryGreen,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          heading != null
                              ? '${heading.toInt()}° (اتجاه الكعبة 136° SE)'
                              : '136° SE (اتجاه مكة المكرمة)',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accentGold,
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 8),
                const Text(
                  'ضع الهاتف على سطح مستوٍ لتوجه البوصلة',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 2. Local Accurate Prayer Times List
          const Text(
            'مواقيت الصلاة الدقيقة (حساب محلي)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          Consumer<PrayerProvider>(
            builder: (context, prayerProv, _) {
              final prayers = prayerProv.todayPrayers;
              final next = prayerProv.nextPrayer;

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: prayers.length,
                itemBuilder: (context, index) {
                  final p = prayers[index];
                  final isNext = next?.name == p.name;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: isNext
                          ? AppColors.primaryGreen
                          : (isDark ? AppColors.darkSurface : Colors.white),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isNext
                            ? AppColors.accentGold
                            : Colors.grey.withOpacity(0.15),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: isNext ? AppColors.accentGold : AppColors.primaryGreen,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              p.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isNext ? Colors.white : null,
                              ),
                            ),
                            if (isNext) ...[
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.accentGold,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'الصلاة القادمة',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        Text(
                          p.time,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isNext ? AppColors.accentGold : AppColors.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
