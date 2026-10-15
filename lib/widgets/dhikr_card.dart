import 'package:flutter/material.dart';
import '../models/dhikr.dart';
import '../theme/app_theme.dart';

class DhikrCard extends StatelessWidget {
  final Dhikr dhikr;
  final VoidCallback onTap;
  final VoidCallback onReset;

  const DhikrCard({
    super.key,
    required this.dhikr,
    required this.onTap,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardBg = dhikr.isCompleted
        ? (isDark ? const Color(0xFF1B3825) : const Color(0xFFE8F5E9))
        : (isDark ? AppColors.darkSurface : Colors.white);

    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    return Card(
      color: cardBg,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'العدد المطلـوب: ${dhikr.targetCount}',
                      style: const TextStyle(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      if (dhikr.isCompleted)
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Icon(Icons.check_circle, color: AppColors.primaryGreen, size: 24),
                        ),
                      IconButton(
                        icon: const Icon(Icons.refresh, size: 20),
                        onPressed: onReset,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        tooltip: 'إعادة التكرار',
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                dhikr.text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  height: 1.6,
                  color: textColor,
                ),
              ),
              if (dhikr.fadl != null && dhikr.fadl!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.primaryGreen.withOpacity(0.2)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.star, size: 16, color: AppColors.accentGold),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          dhikr.fadl!,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: LinearProgressIndicator(
                      value: dhikr.progress,
                      minHeight: 28,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
                    ),
                  ),
                  Text(
                    '${dhikr.currentCount} / ${dhikr.targetCount}',
                    style: TextStyle(
                      color: dhikr.progress > 0.5 ? Colors.white : AppColors.primaryGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
