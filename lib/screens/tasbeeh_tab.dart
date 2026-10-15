import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tasbeeh_provider.dart';
import '../theme/app_theme.dart';

class TasbeehTab extends StatelessWidget {
  const TasbeehTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<TasbeehProvider>(
      builder: (context, tasbeeh, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Zikr Selector Dropdown/Chips
              const Text(
                'اختر صيغة الذكر:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 48,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: tasbeeh.phrases.length,
                  itemBuilder: (context, index) {
                    final phrase = tasbeeh.phrases[index];
                    final isSelected = phrase == tasbeeh.selectedPhrase;
                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: ChoiceChip(
                        label: Text(phrase),
                        selected: isSelected,
                        selectedColor: AppColors.primaryGreen,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black80),
                          fontWeight: FontWeight.bold,
                        ),
                        onSelected: (_) => tasbeeh.setSelectedPhrase(phrase),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Target count selector
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'الهدف المطلوب:',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [33, 100, 1000].map((targetVal) {
                      final isSel = tasbeeh.target == targetVal;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: isSel ? AppColors.accentGold : Colors.transparent,
                            foregroundColor: isSel ? Colors.black : AppColors.primaryGreen,
                            side: BorderSide(
                              color: isSel ? AppColors.accentGold : AppColors.primaryGreen,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            minimumSize: const Size(40, 32),
                          ),
                          onPressed: () => tasbeeh.setTarget(targetVal),
                          child: Text('$targetVal'),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // 2. Main Interactive Tasbeeh Circular Counter Button
              Center(
                child: GestureDetector(
                  onTap: tasbeeh.increment,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 240,
                        height: 240,
                        child: CircularProgressIndicator(
                          value: tasbeeh.progress,
                          strokeWidth: 12,
                          backgroundColor: Colors.grey[200],
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
                        ),
                      ),
                      Container(
                        width: 210,
                        height: 210,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark ? AppColors.darkSurface : Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryGreen.withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                          border: Border.all(color: AppColors.accentGold, width: 2),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${tasbeeh.count}',
                              style: const TextStyle(
                                fontSize: 52,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryGreen,
                              ),
                            ),
                            Text(
                              '/ ${tasbeeh.target}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'اضغط للتسبيح',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.accentGold,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Total lifetime counts & Reset Actions
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'إجمالي التسبيحات كُلِّها',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          '${tasbeeh.totalCount}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.redAccent),
                      tooltip: 'تصفير العداد الحالي',
                      onPressed: () {
                        tasbeeh.resetCount();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
