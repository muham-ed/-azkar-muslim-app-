class Surah {
  final int number;
  final String name;
  final String englishName;
  final int versesCount;
  final String type; // مكية أو مدنية
  final String versesText;

  Surah({
    required this.number,
    required this.name,
    required this.englishName,
    required this.versesCount,
    required this.type,
    required this.versesText,
  });
}
