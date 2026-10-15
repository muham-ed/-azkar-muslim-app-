import 'package:audioplayers/audioplayers.dart';

/// تشغيل تلاوة سورة كاملة بالبث.
/// الخادم الافتراضي للشيخ مشاري العفاسي على mp3quran.net.
/// تحقق من الرابط الحالي ومن شروط الاستخدام قبل النشر:
///   https://mp3quran.net/api/v3/reciters  (حقل moshaf[].server)
class QuranAudioService {
  static const String defaultServer = 'https://server8.mp3quran.net/afs/';

  final AudioPlayer _player = AudioPlayer();

  static String surahUrl(int surah, {String server = defaultServer}) {
    assert(surah >= 1 && surah <= 114);
    return '$server${surah.toString().padLeft(3, '0')}.mp3';
  }

  Stream<PlayerState> get state => _player.onPlayerStateChanged;
  Stream<Duration> get position => _player.onPositionChanged;
  Stream<Duration> get duration => _player.onDurationChanged;

  Future<void> playSurah(int surah, {String server = defaultServer}) =>
      _player.play(UrlSource(surahUrl(surah, server: server)));

  Future<void> pause() => _player.pause();
  Future<void> resume() => _player.resume();
  Future<void> stop() => _player.stop();
  Future<void> seek(Duration d) => _player.seek(d);
  Future<void> dispose() => _player.dispose();
}
