import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

class TasbeehProvider with ChangeNotifier {
  static const String _countKey = 'tasbeeh_current_count';
  static const String _totalKey = 'tasbeeh_total_count';
  static const String _targetKey = 'tasbeeh_target_count';
  static const String _phraseKey = 'tasbeeh_selected_phrase';

  int _count = 0;
  int _totalCount = 0;
  int _target = 33;
  String _selectedPhrase = 'سُبْحَانَ اللَّهِ';

  final List<String> _phrases = [
    'سُبْحَانَ اللَّهِ',
    'الْحَمْدُ لِلَّهِ',
    'اللَّهُ أَكْبَرُ',
    'لَا إِلَهَ إِلَّا اللَّهُ',
    'أَسْتَغْفِرُ اللَّهَ وَأَتُوبُ إِلَيْهِ',
    'اللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى نَبِيِّنَا مُحَمَّدٍ',
    'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
    'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ ، سُبْحَانَ اللَّهِ الْعَظِيمِ',
  ];

  int get count => _count;
  int get totalCount => _totalCount;
  int get target => _target;
  String get selectedPhrase => _selectedPhrase;
  List<String> get phrases => _phrases;
  double get progress => _target <= 0 ? 0 : (_count / _target).clamp(0.0, 1.0);

  TasbeehProvider() {
    _loadState();
  }

  void setSelectedPhrase(String phrase) {
    _selectedPhrase = phrase;
    _count = 0;
    notifyListeners();
    _saveState();
  }

  void setTarget(int newTarget) {
    _target = newTarget;
    notifyListeners();
    _saveState();
  }

  void increment() async {
    _count++;
    _totalCount++;
    if (await Vibration.hasVibrator() ?? false) {
      if (_count == _target) {
        Vibration.vibrate(pattern: [0, 100, 50, 100]); // اهتزاز مميز عند اكتمال الهدف
      } else {
        Vibration.vibrate(duration: 40);
      }
    }
    notifyListeners();
    _saveState();
  }

  void resetCount() {
    _count = 0;
    notifyListeners();
    _saveState();
  }

  void resetTotal() {
    _totalCount = 0;
    _count = 0;
    notifyListeners();
    _saveState();
  }

  Future<void> _saveState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_countKey, _count);
      await prefs.setInt(_totalKey, _totalCount);
      await prefs.setInt(_targetKey, _target);
      await prefs.setString(_phraseKey, _selectedPhrase);
    } catch (e) {
      debugPrint('Error saving tasbeeh state: $e');
    }
  }

  Future<void> _loadState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _count = prefs.getInt(_countKey) ?? 0;
      _totalCount = prefs.getInt(_totalKey) ?? 0;
      _target = prefs.getInt(_targetKey) ?? 33;
      _selectedPhrase = prefs.getString(_phraseKey) ?? 'سُبْحَانَ اللَّهِ';
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading tasbeeh state: $e');
    }
  }
}
