import 'dart:convert';
import 'package:flutter/services.dart';

/// Service for finding similar ayahs throughout the Quran
class AyahSimilarityService {
  static const String _quranPath = 'assets/data/quran/complete_quran.json';
  
  /// Find similar ayahs based on themes, keywords, and patterns
  static Future<List<SimilarAyah>> findSimilarAyahs({
    required int surahNumber,
    required int ayahNumber,
    required String arabicText,
    required String englishText,
  }) async {
    try {
      // Load complete Quran data
      final quranData = await _loadQuranData();
      if (quranData == null) return [];
      
      // Extract themes and keywords from the current ayah
      final themes = _extractThemes(arabicText, englishText);
      final keywords = _extractKeywords(arabicText, englishText);
      
      // Find similar ayahs
      final similarAyahs = <SimilarAyah>[];
      
      for (final surah in quranData.surahs) {
        for (final ayah in surah.ayahs) {
          // Skip the same ayah
          if (surah.number == surahNumber && ayah.ayahNumber == ayahNumber) {
            continue;
          }
          
          // Calculate similarity score
          final similarityScore = _calculateSimilarityScore(
            themes: themes,
            keywords: keywords,
            targetArabic: ayah.arabic,
            targetEnglish: ayah.english,
          );
          
          // Only include ayahs with significant similarity
          if (similarityScore > 0.3) {
            similarAyahs.add(SimilarAyah(
              surahNumber: surah.number,
              surahName: surah.nameEnglish,
              ayahNumber: ayah.ayahNumber,
              arabicText: ayah.arabic,
              englishText: ayah.english,
              similarityScore: similarityScore,
              similarityType: _determineSimilarityType(themes, keywords, arabicText, englishText, ayah.arabic, ayah.english),
              connectionReason: _getConnectionReason(themes, keywords, arabicText, englishText, ayah.arabic, ayah.english),
            ));
          }
        }
      }
      
      // Sort by similarity score and return top results
      similarAyahs.sort((a, b) => b.similarityScore.compareTo(a.similarityScore));
      return similarAyahs.take(10).toList();
      
    } catch (e) {
      print('Error finding similar ayahs: $e');
      return [];
    }
  }
  
  /// Load complete Quran data
  static Future<QuranData?> _loadQuranData() async {
    try {
      final String jsonString = await rootBundle.loadString(_quranPath);
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      return QuranData.fromJson(jsonData);
    } catch (e) {
      print('Error loading Quran data: $e');
      return null;
    }
  }
  
  /// Extract themes from ayah text
  static List<String> _extractThemes(String arabicText, String englishText) {
    final themes = <String>{};
    // Prioritize English text for better AI understanding
    final text = '$englishText $arabicText'.toLowerCase();
    
    // Common Islamic themes and concepts
    final themeKeywords = {
      'worship': ['worship', 'prayer', 'salah', 'عبادة', 'صلاة'],
      'guidance': ['guidance', 'huda', 'هدى', 'هداية'],
      'mercy': ['mercy', 'rahman', 'raheem', 'رحمن', 'رحيم'],
      'forgiveness': ['forgiveness', 'forgive', 'مغفرة', 'غفر'],
      'patience': ['patience', 'sabr', 'صبر', 'صابر'],
      'gratitude': ['gratitude', 'shukr', 'شكر', 'شاكر'],
      'fear': ['fear', 'taqwa', 'تقوى', 'خوف'],
      'hope': ['hope', 'raja', 'رجاء', 'أمل'],
      'justice': ['justice', 'adl', 'عدل', 'عدالة'],
      'knowledge': ['knowledge', 'ilm', 'علم', 'معرفة'],
      'wisdom': ['wisdom', 'hikmah', 'حكمة', 'حكيم'],
      'truth': ['truth', 'haqq', 'حق', 'صحيح'],
      'falsehood': ['falsehood', 'batil', 'باطل', 'كذب'],
      'believers': ['believers', 'mu\'min', 'مؤمن', 'مؤمنون'],
      'disbelievers': ['disbelievers', 'kafir', 'كافر', 'كافرون'],
      'hypocrites': ['hypocrites', 'munafiq', 'منافق', 'منافقون'],
      'paradise': ['paradise', 'jannah', 'جنة', 'فردوس'],
      'hell': ['hell', 'jahannam', 'جهنم', 'نار'],
      'day of judgment': ['judgment', 'qiyamah', 'قيامة', 'يوم القيامة'],
      'revelation': ['revelation', 'wahy', 'وحي', 'تنزيل'],
      'prophets': ['prophets', 'anbiya', 'أنبياء', 'رسل'],
    };
    
    for (final entry in themeKeywords.entries) {
      for (final keyword in entry.value) {
        if (text.contains(keyword)) {
          themes.add(entry.key);
        }
      }
    }
    
    return themes.toList();
  }
  
  /// Extract keywords from ayah text
  static List<String> _extractKeywords(String arabicText, String englishText) {
    final keywords = <String>{};
    // Prioritize English text for better AI understanding
    final text = '$englishText $arabicText'.toLowerCase();
    
    // Common Arabic words and their English translations
    final keywordMap = {
      'allah': ['الله', 'allahu', 'allah'],
      'lord': ['رب', 'rabb', 'lord'],
      'merciful': ['رحمن', 'رحيم', 'merciful', 'compassionate'],
      'king': ['ملك', 'malik', 'king'],
      'master': ['سيد', 'sayyid', 'master'],
      'creator': ['خالق', 'khaliq', 'creator'],
      'sustainer': ['رزاق', 'razzaq', 'sustainer'],
      'forgiver': ['غفار', 'ghaffar', 'forgiver'],
      'guide': ['هادي', 'hadi', 'guide'],
      'protector': ['حافظ', 'hafiz', 'protector'],
      'judge': ['حاكم', 'hakim', 'judge'],
      'witness': ['شاهد', 'shahid', 'witness'],
      'truth': ['حق', 'haqq', 'truth'],
      'light': ['نور', 'nur', 'light'],
      'darkness': ['ظلام', 'zulm', 'darkness'],
      'life': ['حياة', 'hayat', 'life'],
      'death': ['موت', 'mawt', 'death'],
      'good': ['خير', 'khayr', 'good'],
      'evil': ['شر', 'sharr', 'evil'],
      'righteous': ['صالح', 'salih', 'righteous'],
      'sinful': ['آثم', 'athim', 'sinful'],
    };
    
    for (final entry in keywordMap.entries) {
      for (final keyword in entry.value) {
        if (text.contains(keyword)) {
          keywords.add(entry.key);
        }
      }
    }
    
    return keywords.toList();
  }
  
  /// Calculate similarity score between two ayahs
  static double _calculateSimilarityScore({
    required List<String> themes,
    required List<String> keywords,
    required String targetArabic,
    required String targetEnglish,
  }) {
    double score = 0.0;
    final targetText = '$targetArabic $targetEnglish'.toLowerCase();
    
    // Theme similarity (40% weight)
    final targetThemes = _extractThemes(targetArabic, targetEnglish);
    final themeMatches = themes.where((theme) => targetThemes.contains(theme)).length;
    score += (themeMatches / themes.length) * 0.4;
    
    // Keyword similarity (30% weight)
    final targetKeywords = _extractKeywords(targetArabic, targetEnglish);
    final keywordMatches = keywords.where((keyword) => targetKeywords.contains(keyword)).length;
    score += (keywordMatches / keywords.length) * 0.3;
    
    // Text similarity (20% weight)
    final textSimilarity = _calculateTextSimilarity(themes, keywords, targetText);
    score += textSimilarity * 0.2;
    
    // Structural similarity (10% weight)
    final structuralSimilarity = _calculateStructuralSimilarity(targetArabic, targetEnglish);
    score += structuralSimilarity * 0.1;
    
    return score.clamp(0.0, 1.0);
  }
  
  /// Calculate text similarity
  static double _calculateTextSimilarity(List<String> themes, List<String> keywords, String targetText) {
    int matches = 0;
    int total = themes.length + keywords.length;
    
    // Prioritize English keywords for better matching
    for (final theme in themes) {
      if (targetText.toLowerCase().contains(theme.toLowerCase())) matches++;
    }
    
    for (final keyword in keywords) {
      if (targetText.toLowerCase().contains(keyword.toLowerCase())) matches++;
    }
    
    return total > 0 ? matches / total : 0.0;
  }
  
  /// Calculate structural similarity
  static double _calculateStructuralSimilarity(String arabic, String english) {
    // Simple structural analysis based on length and patterns
    final arabicLength = arabic.length;
    final englishLength = english.split(' ').length;
    
    // Normalize lengths (this is a simplified approach)
    final lengthScore = 1.0 - (arabicLength - 50).abs() / 100.0;
    final wordScore = 1.0 - (englishLength - 10).abs() / 20.0;
    
    return (lengthScore + wordScore) / 2.0;
  }
  
  /// Determine the type of similarity
  static String _determineSimilarityType(List<String> themes, List<String> keywords, String arabicText, String englishText, String targetArabic, String targetEnglish) {
    final targetThemes = _extractThemes(targetArabic, targetEnglish);
    final targetKeywords = _extractKeywords(targetArabic, targetEnglish);
    
    // Check for exact theme matches
    final themeMatches = themes.where((theme) => targetThemes.contains(theme)).length;
    if (themeMatches >= 3) return 'Thematic Similarity';
    
    // Check for keyword matches
    final keywordMatches = keywords.where((keyword) => targetKeywords.contains(keyword)).length;
    if (keywordMatches >= 3) return 'Keyword Similarity';
    
    // Check for structural similarity
    if (targetArabic.length - arabicText.length < 20) return 'Structural Similarity';
    
    return 'General Similarity';
  }
  
  /// Get connection reason
  static String _getConnectionReason(List<String> themes, List<String> keywords, String arabicText, String englishText, String targetArabic, String targetEnglish) {
    final targetThemes = _extractThemes(targetArabic, targetEnglish);
    final targetKeywords = _extractKeywords(targetArabic, targetEnglish);
    
    final commonThemes = themes.where((theme) => targetThemes.contains(theme)).toList();
    final commonKeywords = keywords.where((keyword) => targetKeywords.contains(keyword)).toList();
    
    if (commonThemes.isNotEmpty) {
      return 'Shares themes: ${commonThemes.take(3).join(', ')}';
    }
    
    if (commonKeywords.isNotEmpty) {
      return 'Shares keywords: ${commonKeywords.take(3).join(', ')}';
    }
    
    return 'Similar content and structure';
  }
}

/// Model for similar ayah
class SimilarAyah {
  final int surahNumber;
  final String surahName;
  final int ayahNumber;
  final String arabicText;
  final String englishText;
  final double similarityScore;
  final String similarityType;
  final String connectionReason;

  SimilarAyah({
    required this.surahNumber,
    required this.surahName,
    required this.ayahNumber,
    required this.arabicText,
    required this.englishText,
    required this.similarityScore,
    required this.similarityType,
    required this.connectionReason,
  });
}

/// Model for Quran data
class QuranData {
  final List<QuranSurah> surahs;

  QuranData({required this.surahs});

  factory QuranData.fromJson(Map<String, dynamic> json) {
    return QuranData(
      surahs: (json['surahs'] as List? ?? [])
          .map((item) => QuranSurah.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Model for Quran surah
class QuranSurah {
  final int number;
  final String nameEnglish;
  final List<QuranAyah> ayahs;

  QuranSurah({
    required this.number,
    required this.nameEnglish,
    required this.ayahs,
  });

  factory QuranSurah.fromJson(Map<String, dynamic> json) {
    return QuranSurah(
      number: json['number'] as int? ?? 0,
      nameEnglish: json['nameEnglish'] as String? ?? '',
      ayahs: (json['ayahs'] as List? ?? [])
          .map((item) => QuranAyah.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Model for Quran ayah
class QuranAyah {
  final int ayahNumber;
  final String arabic;
  final String english;

  QuranAyah({
    required this.ayahNumber,
    required this.arabic,
    required this.english,
  });

  factory QuranAyah.fromJson(Map<String, dynamic> json) {
    return QuranAyah(
      ayahNumber: json['ayahNumber'] as int? ?? 0,
      arabic: json['arabic'] as String? ?? '',
      english: json['english'] as String? ?? '',
    );
  }
}
