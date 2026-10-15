class Dhikr {
  final String id;
  final String text;
  final String? fadl;
  final int targetCount;
  int currentCount;

  Dhikr({
    required this.id,
    required this.text,
    this.fadl,
    required this.targetCount,
    this.currentCount = 0,
  });

  bool get isCompleted => currentCount >= targetCount;
  double get progress => targetCount == 0 ? 0.0 : (currentCount / targetCount).clamp(0.0, 1.0);

  void increment() {
    if (currentCount < targetCount) {
      currentCount++;
    }
  }

  void reset() {
    currentCount = 0;
  }
}

class DhikrCategory {
  final String name;
  final String iconName;
  final List<Dhikr> dhikrs;

  DhikrCategory({
    required this.name,
    this.iconName = 'book',
    required this.dhikrs,
  });

  int get completedCount => dhikrs.where((d) => d.isCompleted).length;
  int get totalCount => dhikrs.length;
  double get progress => totalCount == 0 ? 0.0 : (completedCount / totalCount).clamp(0.0, 1.0);
}
