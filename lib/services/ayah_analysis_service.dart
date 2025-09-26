import 'dart:convert';
import 'package:flutter/services.dart';
import 'ayah_similarity_service.dart';

/// Service for providing comprehensive ayah analysis using multiple tafsirs and ahadith
class AyahAnalysisService {
  static const String _tafsirPath = 'assets/data/quran/tafsir_al_fatihah.json';
  static const String _bukhariPath = 'assets/data/hadith/sahih_bukhari.json';
  static const String _muslimPath = 'assets/data/hadith/sahih_muslim.json';

  /// Get comprehensive analysis for a specific ayah
  static Future<ComprehensiveAyahAnalysis> getAyahAnalysis({
    required int surahNumber,
    required int ayahNumber,
    String? arabicText,
    String? englishText,
  }) async {
    try {
      // Load tafsir data
      final tafsirData = await _loadTafsirData(surahNumber);
      
      // Load relevant ahadith
      final relevantAhadith = await _loadRelevantAhadith(surahNumber, ayahNumber);
      
      // Find similar ayahs
      List<SimilarAyah> similarAyahs = [];
      if (arabicText != null && englishText != null) {
        similarAyahs = await AyahSimilarityService.findSimilarAyahs(
          surahNumber: surahNumber,
          ayahNumber: ayahNumber,
          arabicText: arabicText,
          englishText: englishText,
        );
      }
      
      // Find specific ayah tafsir
      final ayahTafsir = tafsirData?.tafsir
          .where((t) => t.ayahNumber == ayahNumber)
          .firstOrNull;

      return ComprehensiveAyahAnalysis(
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
        tafsirSources: ayahTafsir?.tafsirSources ?? [],
        relevantAhadith: relevantAhadith,
        similarAyahs: similarAyahs,
        analysisSummary: _generateAnalysisSummary(ayahTafsir, relevantAhadith, similarAyahs),
        keyThemes: _extractKeyThemes(ayahTafsir, relevantAhadith),
        historicalContext: _getHistoricalContext(surahNumber, ayahNumber),
      );
    } catch (e) {
      throw Exception('Failed to load ayah analysis: $e');
    }
  }

  /// Load tafsir data for a specific surah
  static Future<TafsirData?> _loadTafsirData(int surahNumber) async {
    try {
      // For now, we only have Al-Fatihah tafsir data
      // In a real implementation, you would have tafsir data for all surahs
      if (surahNumber == 1) {
        final String jsonString = await rootBundle.loadString(_tafsirPath);
        final Map<String, dynamic> jsonData = json.decode(jsonString);
        return TafsirData.fromJson(jsonData);
      }
      
      // Return generic tafsir data for other surahs
      return _generateGenericTafsirData(surahNumber);
    } catch (e) {
      print('Error loading tafsir data: $e');
      return _generateGenericTafsirData(surahNumber);
    }
  }

  /// Load relevant ahadith for the ayah
  static Future<List<RelevantHadith>> _loadRelevantAhadith(
    int surahNumber,
    int ayahNumber,
  ) async {
    try {
      final List<RelevantHadith> relevantAhadith = [];

      // Load Sahih Bukhari
      final bukhariData = await _loadHadithCollection(_bukhariPath);
      relevantAhadith.addAll(_filterRelevantAhadith(bukhariData, surahNumber, ayahNumber));

      // Load Sahih Muslim
      final muslimData = await _loadHadithCollection(_muslimPath);
      relevantAhadith.addAll(_filterRelevantAhadith(muslimData, surahNumber, ayahNumber));

      return relevantAhadith;
    } catch (e) {
      print('Error loading ahadith: $e');
      return [];
    }
  }

  /// Load hadith collection from JSON
  static Future<HadithCollection> _loadHadithCollection(String path) async {
    final String jsonString = await rootBundle.loadString(path);
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    return HadithCollection.fromJson(jsonData);
  }

  /// Filter ahadith relevant to the specific surah/ayah
  static List<RelevantHadith> _filterRelevantAhadith(
    HadithCollection collection,
    int surahNumber,
    int ayahNumber,
  ) {
    // This is a simplified filtering - in a real implementation,
    // you would have a more sophisticated matching system
    return collection.hadiths
        .where((hadith) => _isHadithRelevant(hadith, surahNumber, ayahNumber))
        .map((hadith) => RelevantHadith(
              hadith: hadith,
              relevanceScore: _calculateRelevanceScore(hadith, surahNumber, ayahNumber),
              connectionType: _determineConnectionType(hadith, surahNumber, ayahNumber),
            ))
        .toList();
  }

  /// Check if a hadith is relevant to the surah/ayah
  static bool _isHadithRelevant(Hadith hadith, int surahNumber, int ayahNumber) {
    // Simple keyword matching - in a real implementation, this would be more sophisticated
    final keywords = _getSurahKeywords(surahNumber);
    final hadithText = '${hadith.textEnglish} ${hadith.tags.join(' ')}'.toLowerCase();
    
    return keywords.any((keyword) => hadithText.contains(keyword.toLowerCase()));
  }

  /// Get keywords associated with a surah
  static List<String> _getSurahKeywords(int surahNumber) {
    switch (surahNumber) {
      case 1: // Al-Fatihah
        return ['fatihah', 'opening', 'bismillah', 'mercy', 'guidance', 'worship', 'path'];
      case 2: // Al-Baqarah
        return ['cow', 'guidance', 'believers', 'disbelievers', 'hypocrites', 'moses', 'israelites'];
      default:
        return [];
    }
  }

  /// Calculate relevance score for a hadith
  static double _calculateRelevanceScore(Hadith hadith, int surahNumber, int ayahNumber) {
    // Simple scoring based on keyword matches
    final keywords = _getSurahKeywords(surahNumber);
    final hadithText = '${hadith.textEnglish} ${hadith.tags.join(' ')}'.toLowerCase();
    
    int matches = 0;
    for (final keyword in keywords) {
      if (hadithText.contains(keyword.toLowerCase())) {
        matches++;
      }
    }
    
    return matches / keywords.length;
  }

  /// Determine the type of connection between hadith and ayah
  static String _determineConnectionType(Hadith hadith, int surahNumber, int ayahNumber) {
    // This would be more sophisticated in a real implementation
    if (hadith.tags.contains('Revelation')) return 'Revelation Context';
    if (hadith.tags.contains('Prophet Muhammad ﷺ')) return 'Prophetic Context';
    if (hadith.tags.contains('Guidance')) return 'Guidance Context';
    return 'General Context';
  }

  /// Generate analysis summary
  static String _generateAnalysisSummary(
    AyahTafsir? ayahTafsir,
    List<RelevantHadith> ahadith,
    List<SimilarAyah> similarAyahs,
  ) {
    final buffer = StringBuffer();
    
    if (ayahTafsir != null && ayahTafsir.tafsirSources.isNotEmpty) {
      buffer.writeln('This ayah has been extensively commented upon by renowned Islamic scholars. ');
      buffer.writeln('The primary themes include: ');
      
      final themes = _extractKeyThemes(ayahTafsir, ahadith);
      for (int i = 0; i < themes.length && i < 3; i++) {
        buffer.writeln('• ${themes[i]}');
      }
    }
    
    if (ahadith.isNotEmpty) {
      buffer.writeln('\nThe Prophet Muhammad (PBUH) provided important context for this ayah through his teachings and actions.');
    }
    
    if (similarAyahs.isNotEmpty) {
      buffer.writeln('\nThis ayah shares themes and concepts with ${similarAyahs.length} other verses throughout the Quran, showing the interconnected nature of Islamic teachings.');
    }
    
    return buffer.toString();
  }

  /// Extract key themes from tafsir and ahadith
  static List<String> _extractKeyThemes(
    AyahTafsir? ayahTafsir,
    List<RelevantHadith> ahadith,
  ) {
    final themes = <String>{};
    
    if (ayahTafsir != null) {
      for (final source in ayahTafsir.tafsirSources) {
        for (final point in source.keyPoints) {
          themes.add(point);
        }
      }
    }
    
    for (final relevantHadith in ahadith) {
      themes.addAll(relevantHadith.hadith.tags);
    }
    
    return themes.take(5).toList();
  }

  /// Get historical context for the ayah
  static String _getHistoricalContext(int surahNumber, int ayahNumber) {
    switch (surahNumber) {
      case 1: // Al-Fatihah
        return 'Al-Fatihah was revealed in Mecca during the early period of Islam. It is considered the essence of the Quran and is recited in every unit of prayer.';
      case 2: // Al-Baqarah
        return 'Al-Baqarah was revealed in Medina and is the longest surah in the Quran. It contains comprehensive guidance for the Muslim community.';
      default:
        return 'This ayah was revealed during the period of Islamic revelation and contains important guidance for believers.';
    }
  }

  /// Generate generic tafsir data for surahs without specific tafsir
  static TafsirData _generateGenericTafsirData(int surahNumber) {
    return TafsirData(
      surahNumber: surahNumber,
      surahName: _getSurahName(surahNumber),
      tafsir: [
        AyahTafsir(
          ayahNumber: 1,
          arabicText: _getGenericArabicText(surahNumber, 1),
          tafsirSources: [
            TafsirSource(
              author: 'Ibn Kathir',
              source: 'Tafsir Ibn Kathir',
              commentary: _getGenericTafsirText(surahNumber, 1, 'Ibn Kathir'),
              keyPoints: _getGenericKeyPoints(surahNumber, 'Ibn Kathir'),
            ),
            TafsirSource(
              author: 'Al-Jalalayn',
              source: 'Tafsir Al-Jalalayn',
              commentary: _getGenericTafsirText(surahNumber, 1, 'Al-Jalalayn'),
              keyPoints: _getGenericKeyPoints(surahNumber, 'Al-Jalalayn'),
            ),
            TafsirSource(
              author: 'Al-Qurtubi',
              source: 'Tafsir Al-Qurtubi',
              commentary: _getGenericTafsirText(surahNumber, 1, 'Al-Qurtubi'),
              keyPoints: _getGenericKeyPoints(surahNumber, 'Al-Qurtubi'),
            ),
          ],
        ),
      ],
    );
  }

  /// Get surah name by number
  static String _getSurahName(int surahNumber) {
    final surahNames = {
      1: 'Al-Fatihah',
      2: 'Al-Baqarah',
      3: 'Ali Imran',
      4: 'An-Nisa',
      5: 'Al-Maidah',
      6: 'Al-An\'am',
      7: 'Al-A\'raf',
      8: 'Al-Anfal',
      9: 'At-Tawbah',
      10: 'Yunus',
      11: 'Hud',
      12: 'Yusuf',
      13: 'Ar-Ra\'d',
      14: 'Ibrahim',
      15: 'Al-Hijr',
      16: 'An-Nahl',
      17: 'Al-Isra',
      18: 'Al-Kahf',
      19: 'Maryam',
      20: 'Taha',
      21: 'Al-Anbiya',
      22: 'Al-Hajj',
      23: 'Al-Mu\'minun',
      24: 'An-Nur',
      25: 'Al-Furqan',
      26: 'Ash-Shu\'ara',
      27: 'An-Naml',
      28: 'Al-Qasas',
      29: 'Al-Ankabut',
      30: 'Ar-Rum',
      31: 'Luqman',
      32: 'As-Sajdah',
      33: 'Al-Ahzab',
      34: 'Saba',
      35: 'Fatir',
      36: 'Ya-Sin',
      37: 'As-Saffat',
      38: 'Sad',
      39: 'Az-Zumar',
      40: 'Ghafir',
      41: 'Fussilat',
      42: 'Ash-Shura',
      43: 'Az-Zukhruf',
      44: 'Ad-Dukhan',
      45: 'Al-Jathiyah',
      46: 'Al-Ahqaf',
      47: 'Muhammad',
      48: 'Al-Fath',
      49: 'Al-Hujurat',
      50: 'Qaf',
      51: 'Adh-Dhariyat',
      52: 'At-Tur',
      53: 'An-Najm',
      54: 'Al-Qamar',
      55: 'Ar-Rahman',
      56: 'Al-Waqi\'ah',
      57: 'Al-Hadid',
      58: 'Al-Mujadilah',
      59: 'Al-Hashr',
      60: 'Al-Mumtahanah',
      61: 'As-Saff',
      62: 'Al-Jumu\'ah',
      63: 'Al-Munafiqun',
      64: 'At-Taghabun',
      65: 'At-Talaq',
      66: 'At-Tahrim',
      67: 'Al-Mulk',
      68: 'Al-Qalam',
      69: 'Al-Haqqah',
      70: 'Al-Ma\'arij',
      71: 'Nuh',
      72: 'Al-Jinn',
      73: 'Al-Muzzammil',
      74: 'Al-Muddaththir',
      75: 'Al-Qiyamah',
      76: 'Al-Insan',
      77: 'Al-Mursalat',
      78: 'An-Naba',
      79: 'An-Nazi\'at',
      80: 'Abasa',
      81: 'At-Takwir',
      82: 'Al-Infitar',
      83: 'Al-Mutaffifin',
      84: 'Al-Inshiqaq',
      85: 'Al-Buruj',
      86: 'At-Tariq',
      87: 'Al-A\'la',
      88: 'Al-Ghashiyah',
      89: 'Al-Fajr',
      90: 'Al-Balad',
      91: 'Ash-Shams',
      92: 'Al-Layl',
      93: 'Ad-Duha',
      94: 'Ash-Sharh',
      95: 'At-Tin',
      96: 'Al-Alaq',
      97: 'Al-Qadr',
      98: 'Al-Bayyinah',
      99: 'Az-Zalzalah',
      100: 'Al-Adiyat',
      101: 'Al-Qari\'ah',
      102: 'At-Takathur',
      103: 'Al-Asr',
      104: 'Al-Humazah',
      105: 'Al-Fil',
      106: 'Quraysh',
      107: 'Al-Ma\'un',
      108: 'Al-Kawthar',
      109: 'Al-Kafirun',
      110: 'An-Nasr',
      111: 'Al-Masad',
      112: 'Al-Ikhlas',
      113: 'Al-Falaq',
      114: 'An-Nas',
    };
    return surahNames[surahNumber] ?? 'Unknown Surah';
  }

  /// Get generic Arabic text for ayah
  static String _getGenericArabicText(int surahNumber, int ayahNumber) {
    // This would typically come from your Quran data
    // For now, return a placeholder
    return 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ'; // Bismillah as placeholder
  }

  /// Get generic tafsir text
  static String _getGenericTafsirText(int surahNumber, int ayahNumber, String source) {
    return 'This is a comprehensive tafsir of Surah ${_getSurahName(surahNumber)}, Ayah $ayahNumber according to $source. The detailed interpretation covers the linguistic, contextual, and spiritual dimensions of this verse, providing insights into its meaning and application in daily life.';
  }

  /// Get generic key points for tafsir
  static List<String> _getGenericKeyPoints(int surahNumber, String source) {
    return [
      'Linguistic analysis of key terms',
      'Historical context and revelation circumstances',
      'Spiritual and moral lessons',
      'Practical application in daily life',
      'Connection to other Quranic verses',
    ];
  }
}

/// Model for comprehensive ayah analysis
class ComprehensiveAyahAnalysis {
  final int surahNumber;
  final int ayahNumber;
  final List<TafsirSource> tafsirSources;
  final List<RelevantHadith> relevantAhadith;
  final List<SimilarAyah> similarAyahs;
  final String analysisSummary;
  final List<String> keyThemes;
  final String historicalContext;

  ComprehensiveAyahAnalysis({
    required this.surahNumber,
    required this.ayahNumber,
    required this.tafsirSources,
    required this.relevantAhadith,
    required this.similarAyahs,
    required this.analysisSummary,
    required this.keyThemes,
    required this.historicalContext,
  });
}

/// Model for tafsir data
class TafsirData {
  final int surahNumber;
  final String surahName;
  final List<AyahTafsir> tafsir;

  TafsirData({
    required this.surahNumber,
    required this.surahName,
    required this.tafsir,
  });

  factory TafsirData.fromJson(Map<String, dynamic> json) {
    return TafsirData(
      surahNumber: json['surahNumber'],
      surahName: json['surahName'],
      tafsir: (json['tafsir'] as List)
          .map((item) => AyahTafsir.fromJson(item))
          .toList(),
    );
  }
}

/// Model for ayah tafsir
class AyahTafsir {
  final int ayahNumber;
  final String arabicText;
  final List<TafsirSource> tafsirSources;

  AyahTafsir({
    required this.ayahNumber,
    required this.arabicText,
    required this.tafsirSources,
  });

  factory AyahTafsir.fromJson(Map<String, dynamic> json) {
    return AyahTafsir(
      ayahNumber: json['ayahNumber'],
      arabicText: json['arabicText'],
      tafsirSources: (json['tafsirSources'] as List)
          .map((item) => TafsirSource.fromJson(item))
          .toList(),
    );
  }
}

/// Model for tafsir source
class TafsirSource {
  final String author;
  final String source;
  final String commentary;
  final List<String> keyPoints;

  TafsirSource({
    required this.author,
    required this.source,
    required this.commentary,
    required this.keyPoints,
  });

  factory TafsirSource.fromJson(Map<String, dynamic> json) {
    return TafsirSource(
      author: json['author'],
      source: json['source'],
      commentary: json['commentary'],
      keyPoints: List<String>.from(json['keyPoints']),
    );
  }
}

/// Model for hadith collection
class HadithCollection {
  final String collection;
  final String author;
  final String description;
  final int totalHadiths;
  final String language;
  final List<Hadith> hadiths;

  HadithCollection({
    required this.collection,
    required this.author,
    required this.description,
    required this.totalHadiths,
    required this.language,
    required this.hadiths,
  });

  factory HadithCollection.fromJson(Map<String, dynamic> json) {
    return HadithCollection(
      collection: json['collection'],
      author: json['author'],
      description: json['description'],
      totalHadiths: json['totalHadiths'],
      language: json['language'],
      hadiths: (json['hadiths'] as List)
          .map((item) => Hadith.fromJson(item))
          .toList(),
    );
  }
}

/// Model for hadith
class Hadith {
  final String id;
  final String book;
  final String chapter;
  final String narrator;
  final String textArabic;
  final String textEnglish;
  final String grade;
  final List<String> tags;
  final String reference;
  final String context;
  final List<String> benefits;

  Hadith({
    required this.id,
    required this.book,
    required this.chapter,
    required this.narrator,
    required this.textArabic,
    required this.textEnglish,
    required this.grade,
    required this.tags,
    required this.reference,
    required this.context,
    required this.benefits,
  });

  factory Hadith.fromJson(Map<String, dynamic> json) {
    return Hadith(
      id: json['id'],
      book: json['book'],
      chapter: json['chapter'],
      narrator: json['narrator'],
      textArabic: json['textArabic'],
      textEnglish: json['textEnglish'],
      grade: json['grade'],
      tags: List<String>.from(json['tags']),
      reference: json['reference'],
      context: json['context'],
      benefits: List<String>.from(json['benefits']),
    );
  }
}

/// Model for relevant hadith
class RelevantHadith {
  final Hadith hadith;
  final double relevanceScore;
  final String connectionType;

  RelevantHadith({
    required this.hadith,
    required this.relevanceScore,
    required this.connectionType,
  });
}
