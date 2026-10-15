import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/surah.dart';
import '../theme/app_theme.dart';

class SurahDetailScreen extends StatefulWidget {
  final Surah surah;

  const SurahDetailScreen({super.key, required this.surah});

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _toggleAudio() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
        setState(() => _isPlaying = false);
      } else {
        setState(() => _isLoading = true);
        // رابط البث المباشر لتلاوة السورة (الشيخ مشاري العفاسي)
        String surahNumFormatted = widget.surah.number.toString().padLeft(3, '0');
        String audioUrl = 'https://server8.mp3quran.net/afs/$surahNumFormatted.mp3';

        await _audioPlayer.play(UrlSource(audioUrl));
        setState(() {
          _isPlaying = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isPlaying = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذر تشغيل الصوت، تحقق من الاتصال بالإنترنت')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('سورة ${widget.surah.name}'),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            margin: const EdgeInsets.only(left: 12),
            decoration: BoxDecoration(
              color: AppColors.accentGold.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${widget.surah.versesCount} آية • ${widget.surah.type}',
              style: const TextStyle(
                color: AppColors.accentGold,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Audio Player Banner
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.record_voice_over, color: AppColors.accentGold),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'تلاوة بصوت الشيخ مشاري العفاسي',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'استماع مباشر بوضوح عالي',
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: _isLoading ? null : _toggleAudio,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: AppColors.accentGold,
                            strokeWidth: 2,
                          ),
                        )
                      : Icon(
                          _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                          color: AppColors.accentGold,
                          size: 38,
                        ),
                ),
              ],
            ),
          ),

          // Verses Surface
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.accentGold.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  widget.surah.versesText,
                  textAlign: TextAlign.justify,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 22,
                    height: 2.2,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    fontFamily: 'Amiri',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
