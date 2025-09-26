import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/quran_models.dart';
import 'api/quran_api_service.dart';
import 'api/hadith_api_service.dart';
import 'api/prayer_times_api_service.dart';
import 'cache_service.dart';

class MockDataService {
  static final QuranApiService _quranApi = QuranApiService();
  static final HadithApiService _hadithApi = HadithApiService();
  static final PrayerTimesApiService _prayerApi = PrayerTimesApiService();
  static final CacheService _cacheService = CacheService();
  // Load Surah data from local JSON files (API disabled for surah list)
  static Future<List<Surah>> getMockSurahs() async {
    print('🔄 Loading surah list from local JSON files...');
    
    // Skip API call for surah list - use local JSON data directly
    print('📖 Using local JSON data for surah list...');
    
    try {
      // Try to load from complete surah info first
      print('📖 Loading surahs from surah_info_complete.json...');
      final String response = await rootBundle.loadString('assets/data/quran/surah_info_complete.json');
      print('📄 Raw JSON loaded, length: ${response.length}');
      final List<dynamic> data = json.decode(response);
      print('📊 JSON parsed, found ${data.length} items');
      final surahs = data.map((json) {
        try {
          return Surah.fromJson(json);
        } catch (e) {
          print('❌ Error parsing surah: $e');
          print('❌ Problematic JSON: $json');
          rethrow;
        }
      }).toList();
      print('✅ Successfully loaded ${surahs.length} surahs from surah_info_complete.json');
      return surahs;
    } catch (e) {
      print('❌ Error loading from surah_info_complete.json: $e');
      print('❌ Error type: ${e.runtimeType}');
      try {
        // Fallback to original surahs.json
        print('🔄 Trying fallback to surahs.json...');
        final String response = await rootBundle.loadString('assets/data/quran/surahs.json');
        print('📄 Raw JSON loaded, length: ${response.length}');
        final List<dynamic> data = json.decode(response);
        print('📊 JSON parsed, found ${data.length} items');
        final surahs = data.map((json) => Surah.fromJson(json)).toList();
        print('✅ Successfully loaded ${surahs.length} surahs from surahs.json');
        return surahs;
      } catch (e2) {
        print('❌ Error loading from surahs.json: $e2');
        print('❌ Error type: ${e2.runtimeType}');
        // Final fallback to hardcoded data
        print('🔄 Using hardcoded fallback data...');
        final fallbackSurahs = _getFallbackSurahs();
        print('📝 Fallback data contains ${fallbackSurahs.length} surahs');
        return fallbackSurahs;
      }
    }
  }

  // Fallback Surah data
  static List<Surah> _getFallbackSurahs() {
    return [
      const Surah(
        number: 1,
        nameArabic: 'الفاتحة',
        nameEnglish: 'Al-Fatihah',
        nameTransliterated: 'Al-Fatihah',
        ayahCount: 7,
        revelationType: 'Meccan',
        revelationOrder: 5,
      ),
      const Surah(
        number: 2,
        nameArabic: 'البقرة',
        nameEnglish: 'Al-Baqarah',
        nameTransliterated: 'Al-Baqarah',
        ayahCount: 286,
        revelationType: 'Medinan',
        revelationOrder: 87,
      ),
      const Surah(
        number: 3,
        nameArabic: 'آل عمران',
        nameEnglish: 'Ali Imran',
        nameTransliterated: 'Ali Imran',
        ayahCount: 200,
        revelationType: 'Medinan',
        revelationOrder: 89,
      ),
      const Surah(
        number: 4,
        nameArabic: 'النساء',
        nameEnglish: 'An-Nisa',
        nameTransliterated: 'An-Nisa',
        ayahCount: 176,
        revelationType: 'Medinan',
        revelationOrder: 92,
      ),
      const Surah(
        number: 5,
        nameArabic: 'المائدة',
        nameEnglish: 'Al-Maidah',
        nameTransliterated: 'Al-Maidah',
        ayahCount: 120,
        revelationType: 'Medinan',
        revelationOrder: 112,
      ),
      const Surah(
        number: 6,
        nameArabic: 'الأنعام',
        nameEnglish: 'Al-Anam',
        nameTransliterated: 'Al-Anam',
        ayahCount: 165,
        revelationType: 'Meccan',
        revelationOrder: 55,
      ),
      const Surah(
        number: 7,
        nameArabic: 'الأعراف',
        nameEnglish: 'Al-Araf',
        nameTransliterated: 'Al-Araf',
        ayahCount: 206,
        revelationType: 'Meccan',
        revelationOrder: 39,
      ),
      const Surah(
        number: 8,
        nameArabic: 'الأنفال',
        nameEnglish: 'Al-Anfal',
        nameTransliterated: 'Al-Anfal',
        ayahCount: 75,
        revelationType: 'Medinan',
        revelationOrder: 88,
      ),
      const Surah(
        number: 9,
        nameArabic: 'التوبة',
        nameEnglish: 'At-Tawbah',
        nameTransliterated: 'At-Tawbah',
        ayahCount: 129,
        revelationType: 'Medinan',
        revelationOrder: 113,
      ),
      const Surah(
        number: 10,
        nameArabic: 'يونس',
        nameEnglish: 'Yunus',
        nameTransliterated: 'Yunus',
        ayahCount: 109,
        revelationType: 'Meccan',
        revelationOrder: 51,
      ),
      const Surah(
        number: 11,
        nameArabic: 'هود',
        nameEnglish: 'Hud',
        nameTransliterated: 'Hud',
        ayahCount: 123,
        revelationType: 'Meccan',
        revelationOrder: 52,
      ),
      const Surah(
        number: 12,
        nameArabic: 'يوسف',
        nameEnglish: 'Yusuf',
        nameTransliterated: 'Yusuf',
        ayahCount: 111,
        revelationType: 'Meccan',
        revelationOrder: 53,
      ),
      const Surah(
        number: 13,
        nameArabic: 'الرعد',
        nameEnglish: 'Ar-Rad',
        nameTransliterated: 'Ar-Rad',
        ayahCount: 43,
        revelationType: 'Medinan',
        revelationOrder: 96,
      ),
      const Surah(
        number: 14,
        nameArabic: 'إبراهيم',
        nameEnglish: 'Ibrahim',
        nameTransliterated: 'Ibrahim',
        ayahCount: 52,
        revelationType: 'Meccan',
        revelationOrder: 72,
      ),
      const Surah(
        number: 15,
        nameArabic: 'الحجر',
        nameEnglish: 'Al-Hijr',
        nameTransliterated: 'Al-Hijr',
        ayahCount: 99,
        revelationType: 'Meccan',
        revelationOrder: 54,
      ),
      const Surah(
        number: 16,
        nameArabic: 'النحل',
        nameEnglish: 'An-Nahl',
        nameTransliterated: 'An-Nahl',
        ayahCount: 128,
        revelationType: 'Meccan',
        revelationOrder: 70,
      ),
      const Surah(
        number: 17,
        nameArabic: 'الإسراء',
        nameEnglish: 'Al-Isra',
        nameTransliterated: 'Al-Isra',
        ayahCount: 111,
        revelationType: 'Meccan',
        revelationOrder: 50,
      ),
      const Surah(
        number: 18,
        nameArabic: 'الكهف',
        nameEnglish: 'Al-Kahf',
        nameTransliterated: 'Al-Kahf',
        ayahCount: 110,
        revelationType: 'Meccan',
        revelationOrder: 69,
      ),
      const Surah(
        number: 19,
        nameArabic: 'مريم',
        nameEnglish: 'Maryam',
        nameTransliterated: 'Maryam',
        ayahCount: 98,
        revelationType: 'Meccan',
        revelationOrder: 44,
      ),
      const Surah(
        number: 20,
        nameArabic: 'طه',
        nameEnglish: 'Taha',
        nameTransliterated: 'Taha',
        ayahCount: 135,
        revelationType: 'Meccan',
        revelationOrder: 45,
      ),
      const Surah(
        number: 21,
        nameArabic: 'الأنبياء',
        nameEnglish: 'Al-Anbiya',
        nameTransliterated: 'Al-Anbiya',
        ayahCount: 112,
        revelationType: 'Meccan',
        revelationOrder: 73,
      ),
      const Surah(
        number: 22,
        nameArabic: 'الحج',
        nameEnglish: 'Al-Hajj',
        nameTransliterated: 'Al-Hajj',
        ayahCount: 78,
        revelationType: 'Medinan',
        revelationOrder: 103,
      ),
      const Surah(
        number: 23,
        nameArabic: 'المؤمنون',
        nameEnglish: 'Al-Muminun',
        nameTransliterated: 'Al-Muminun',
        ayahCount: 118,
        revelationType: 'Meccan',
        revelationOrder: 74,
      ),
      const Surah(
        number: 24,
        nameArabic: 'النور',
        nameEnglish: 'An-Nur',
        nameTransliterated: 'An-Nur',
        ayahCount: 64,
        revelationType: 'Medinan',
        revelationOrder: 102,
      ),
      const Surah(
        number: 25,
        nameArabic: 'الفرقان',
        nameEnglish: 'Al-Furqan',
        nameTransliterated: 'Al-Furqan',
        ayahCount: 77,
        revelationType: 'Meccan',
        revelationOrder: 42,
      ),
      const Surah(
        number: 26,
        nameArabic: 'الشعراء',
        nameEnglish: 'Ash-Shuara',
        nameTransliterated: 'Ash-Shuara',
        ayahCount: 227,
        revelationType: 'Meccan',
        revelationOrder: 47,
      ),
      const Surah(
        number: 27,
        nameArabic: 'النمل',
        nameEnglish: 'An-Naml',
        nameTransliterated: 'An-Naml',
        ayahCount: 93,
        revelationType: 'Meccan',
        revelationOrder: 48,
      ),
      const Surah(
        number: 28,
        nameArabic: 'القصص',
        nameEnglish: 'Al-Qasas',
        nameTransliterated: 'Al-Qasas',
        ayahCount: 88,
        revelationType: 'Meccan',
        revelationOrder: 49,
      ),
      const Surah(
        number: 29,
        nameArabic: 'العنكبوت',
        nameEnglish: 'Al-Ankabut',
        nameTransliterated: 'Al-Ankabut',
        ayahCount: 69,
        revelationType: 'Meccan',
        revelationOrder: 85,
      ),
      const Surah(
        number: 30,
        nameArabic: 'الروم',
        nameEnglish: 'Ar-Rum',
        nameTransliterated: 'Ar-Rum',
        ayahCount: 60,
        revelationType: 'Meccan',
        revelationOrder: 84,
      ),
    ];
  }

  // Load Al-Fatihah data from JSON file
  static Future<List<Ayah>> getAlFatihahAyahs() async {
    try {
      final String response = await rootBundle.loadString('assets/data/quran/al_fatihah.json');
      final Map<String, dynamic> data = json.decode(response);
      final List<dynamic> ayahsData = data['ayahs'];
      return ayahsData.map((json) {
        final ayah = Ayah.fromJson(json);
        // Add tafsir data for Al-Fatihah
        return Ayah(
          surahNumber: ayah.surahNumber,
          ayahNumber: ayah.ayahNumber,
          arabicText: ayah.arabicText,
          words: ayah.words,
          translations: ayah.translations,
          juz: ayah.juz,
          hizb: ayah.hizb,
          rub: ayah.rub,
          tafsir: _getTafsirForAyah(ayah.surahNumber, ayah.ayahNumber),
        );
      }).toList();
    } catch (e) {
      // Fallback to hardcoded data if JSON loading fails
      return _getFallbackAyahs();
    }
  }

  // Load ayahs for a specific surah by number
  static Future<List<Ayah>> getAyahsForSurah(int surahNumber) async {
    print('🔄 Loading ayahs for surah $surahNumber...');
    
    try {
      // Try to get from API first
      print('📡 Trying API for surah $surahNumber...');
      final ayahs = await _quranApi.getAyahsForSurah(surahNumber);
      if (ayahs.isNotEmpty) {
        print('✅ API returned ${ayahs.length} ayahs for surah $surahNumber');
        return ayahs;
      }
    } catch (e) {
      print('❌ API failed for surah $surahNumber: $e');
    }
    
    try {
      // Try to load from complete Quran data file first (contains some surahs)
      print('📖 Trying complete_quran.json for surah $surahNumber...');
      final ayahs = await _getAyahsFromCompleteQuran(surahNumber);
      print('✅ Complete Quran returned ${ayahs.length} ayahs for surah $surahNumber');
      return ayahs;
    } catch (e) {
      print('❌ Complete Quran failed for surah $surahNumber: $e');
      try {
        // Try to load from individual surah files
        print('📄 Trying individual file for surah $surahNumber...');
        final ayahs = await _getAyahsFromIndividualFile(surahNumber);
        print('✅ Individual file returned ${ayahs.length} ayahs for surah $surahNumber');
        return ayahs;
      } catch (e2) {
        print('❌ Individual file failed for surah $surahNumber: $e2');
        print('🔄 Falling back to mock data for surah $surahNumber...');
        // Final fallback to mock data
        final mockAyahs = await _getMockAyahsForSurah(surahNumber);
        print('📝 Mock data returned ${mockAyahs.length} ayahs for surah $surahNumber');
        return mockAyahs;
      }
    }
  }

  // Load Al-Baqarah data from JSON file
  static Future<List<Ayah>> _getAlBaqarahAyahs() async {
    try {
      final String response = await rootBundle.loadString('assets/data/quran/al_baqarah_1_10.json');
      final Map<String, dynamic> data = json.decode(response);
      final List<dynamic> ayahsData = data['ayahs'];
      return ayahsData.map((json) {
        final ayah = Ayah.fromJson(json);
        // Add tafsir data for Al-Baqarah
        return Ayah(
          surahNumber: ayah.surahNumber,
          ayahNumber: ayah.ayahNumber,
          arabicText: ayah.arabicText,
          words: ayah.words,
          translations: ayah.translations,
          juz: ayah.juz,
          hizb: ayah.hizb,
          rub: ayah.rub,
          tafsir: _getTafsirForAyah(ayah.surahNumber, ayah.ayahNumber),
        );
      }).toList();
    } catch (e) {
      // Fallback to mock data if JSON loading fails
      return await _getMockAyahsForSurah(2);
    }
  }

  // Load ayahs from complete Quran data file
  static Future<List<Ayah>> _getAyahsFromCompleteQuran(int surahNumber) async {
    try {
      print('Loading ayahs for surah $surahNumber from complete_quran.json...');
      final String response = await rootBundle.loadString('assets/data/quran/complete_quran.json');
      final Map<String, dynamic> data = json.decode(response);
      final List<dynamic> surahs = data['surahs'];
      
      print('Found ${surahs.length} surahs in complete_quran.json');
      
      // Find the specific surah
      final surahData = surahs.cast<Map<String, dynamic>>().firstWhere(
        (surah) => surah['number'] == surahNumber,
        orElse: () => <String, dynamic>{},
      );
      
      if (surahData.isNotEmpty && surahData['ayahs'] != null) {
        final List<dynamic> ayahsData = surahData['ayahs'];
        print('Found ${ayahsData.length} ayahs for surah $surahNumber');
        return ayahsData.map((json) {
          final ayah = Ayah.fromJson(json);
          // Add tafsir data
          return Ayah(
            surahNumber: ayah.surahNumber,
            ayahNumber: ayah.ayahNumber,
            arabicText: ayah.arabicText,
            words: ayah.words,
            translations: ayah.translations,
            juz: ayah.juz,
            hizb: ayah.hizb,
            rub: ayah.rub,
            tafsir: _getTafsirForAyah(ayah.surahNumber, ayah.ayahNumber),
          );
        }).toList();
      } else {
        print('Surah $surahNumber not found in complete_quran.json or has no ayahs');
        // Throw exception to trigger individual file loading
        throw Exception('Surah $surahNumber not found in complete_quran.json');
      }
    } catch (e) {
      print('Error loading surah $surahNumber from complete_quran.json: $e');
      // This will be caught by the outer try-catch and trigger individual file loading
      rethrow;
    }
  }

  // Load ayahs from individual surah files
  static Future<List<Ayah>> _getAyahsFromIndividualFile(int surahNumber) async {
    // Mapping of surah numbers to their individual file names
    final Map<int, String> surahFileMap = {
      1: 'al_fatihah.json',
      2: 'al_baqarah_1_10.json',
      103: 'al_asr.json',
      105: 'al_fil.json',
      108: 'al_kawthar.json',
      109: 'al_kafirun.json',
      110: 'an_nasr.json',
      112: 'al_ikhlas.json',
      113: 'al_falaq.json',
      114: 'an_nas.json',
    };

    final fileName = surahFileMap[surahNumber];
    if (fileName == null) {
      throw Exception('No individual file found for surah $surahNumber');
    }

    try {
      print('Loading ayahs for surah $surahNumber from $fileName...');
      final String response = await rootBundle.loadString('assets/data/quran/$fileName');
      final Map<String, dynamic> data = json.decode(response);
      
      // Extract ayahs array from the JSON structure
      if (!data.containsKey('ayahs') || data['ayahs'] is! List) {
        throw Exception('Expected "ayahs" array not found in $fileName');
      }
      
      final List<dynamic> ayahsData = data['ayahs'];

      print('Found ${ayahsData.length} ayahs for surah $surahNumber in $fileName');
      
      return ayahsData.map((json) {
        final ayah = Ayah.fromJson(json);
        // Add tafsir data
        return Ayah(
          surahNumber: ayah.surahNumber,
          ayahNumber: ayah.ayahNumber,
          arabicText: ayah.arabicText,
          words: ayah.words,
          translations: ayah.translations,
          juz: ayah.juz,
          hizb: ayah.hizb,
          rub: ayah.rub,
          tafsir: _getTafsirForAyah(ayah.surahNumber, ayah.ayahNumber),
        );
      }).toList();
    } catch (e) {
      print('Error loading surah $surahNumber from $fileName: $e');
      rethrow;
    }
  }

  // Mock Ayah data for Al-Fatihah (fallback)
  static List<Ayah> _getFallbackAyahs() {
    return [
      Ayah(
        surahNumber: 1,
        ayahNumber: 1,
        arabicText: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        words: [
          const Word(
            arabic: 'بِسْمِ',
            transliteration: 'bismi',
            root: 'س م و',
            meaning: 'In the name of',
            contextualMeaning: 'In the name of Allah',
            position: 1,
            relatedWords: ['اسم', 'تسمية'],
            partOfSpeech: 'preposition',
            grammar: 'genitive',
          ),
          const Word(
            arabic: 'اللَّهِ',
            transliteration: 'Allahi',
            root: 'أ ل ه',
            meaning: 'Allah',
            contextualMeaning: 'Allah, the One God',
            position: 2,
            relatedWords: ['إله', 'اللاهوت'],
            partOfSpeech: 'proper noun',
            grammar: 'genitive',
          ),
          const Word(
            arabic: 'الرَّحْمَٰنِ',
            transliteration: 'ar-Rahmani',
            root: 'ر ح م',
            meaning: 'The Most Gracious',
            contextualMeaning: 'The Most Gracious, the Beneficent',
            position: 3,
            relatedWords: ['رحمة', 'رحيم'],
            partOfSpeech: 'adjective',
            grammar: 'genitive',
          ),
          const Word(
            arabic: 'الرَّحِيمِ',
            transliteration: 'ar-Raheemi',
            root: 'ر ح م',
            meaning: 'The Most Merciful',
            contextualMeaning: 'The Most Merciful, the Compassionate',
            position: 4,
            relatedWords: ['رحمة', 'رحمن'],
            partOfSpeech: 'adjective',
            grammar: 'genitive',
          ),
        ],
        translations: [
          const Translation(
            translator: 'Sahih International',
            language: 'English',
            text: 'In the name of Allah, the Entirely Merciful, the Especially Merciful.',
            source: 'Sahih International Translation',
          ),
        ],
        juz: 1,
        hizb: 1,
        rub: 1,
        tafsir: 'This verse begins with the name of Allah, the Most Gracious, the Most Merciful. It establishes the foundation of Islamic belief in the oneness of Allah and His attributes of mercy and grace. This opening phrase (Bismillah) is used by Muslims before beginning any important task, seeking Allah\'s blessings and guidance.',
      ),
      Ayah(
        surahNumber: 1,
        ayahNumber: 2,
        arabicText: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
        words: [
          const Word(
            arabic: 'الْحَمْدُ',
            transliteration: 'al-hamdu',
            root: 'ح م د',
            meaning: 'All praise',
            contextualMeaning: 'All praise and thanks',
            position: 1,
            relatedWords: ['حمد', 'محمود'],
            partOfSpeech: 'noun',
            grammar: 'nominative',
          ),
          const Word(
            arabic: 'لِلَّهِ',
            transliteration: 'lillahi',
            root: 'أ ل ه',
            meaning: 'to Allah',
            contextualMeaning: 'belongs to Allah',
            position: 2,
            relatedWords: ['إله', 'اللاهوت'],
            partOfSpeech: 'preposition + proper noun',
            grammar: 'genitive',
          ),
          const Word(
            arabic: 'رَبِّ',
            transliteration: 'Rabb',
            root: 'ر ب ب',
            meaning: 'Lord',
            contextualMeaning: 'Lord and Master',
            position: 3,
            relatedWords: ['ربوبية', 'مربوب'],
            partOfSpeech: 'noun',
            grammar: 'genitive',
          ),
          const Word(
            arabic: 'الْعَالَمِينَ',
            transliteration: 'al-alameen',
            root: 'ع ل م',
            meaning: 'the worlds',
            contextualMeaning: 'all the worlds and universes',
            position: 4,
            relatedWords: ['عالم', 'علم'],
            partOfSpeech: 'noun',
            grammar: 'genitive plural',
          ),
        ],
        translations: [
          const Translation(
            translator: 'Sahih International',
            language: 'English',
            text: '[All] praise is [due] to Allah, Lord of the worlds.',
            source: 'Sahih International Translation',
          ),
        ],
        juz: 1,
        hizb: 1,
        rub: 1,
        tafsir: 'All praise is due to Allah, the Lord of all the worlds. This verse teaches us to acknowledge Allah\'s sovereignty over all creation and to express gratitude for His countless blessings. It establishes the proper attitude of a believer towards Allah - one of praise, gratitude, and recognition of His lordship.',
      ),
      Ayah(
        surahNumber: 1,
        ayahNumber: 3,
        arabicText: 'الرَّحْمَٰنِ الرَّحِيمِ',
        words: [
          const Word(
            arabic: 'الرَّحْمَٰنِ',
            transliteration: 'ar-Rahmani',
            root: 'ر ح م',
            meaning: 'The Most Gracious',
            contextualMeaning: 'The Most Gracious, the Beneficent',
            position: 1,
            relatedWords: ['رحمة', 'رحيم'],
            partOfSpeech: 'adjective',
            grammar: 'genitive',
          ),
          const Word(
            arabic: 'الرَّحِيمِ',
            transliteration: 'ar-Raheemi',
            root: 'ر ح م',
            meaning: 'The Most Merciful',
            contextualMeaning: 'The Most Merciful, the Compassionate',
            position: 2,
            relatedWords: ['رحمة', 'رحمن'],
            partOfSpeech: 'adjective',
            grammar: 'genitive',
          ),
        ],
        translations: [
          const Translation(
            translator: 'Sahih International',
            language: 'English',
            text: 'The Entirely Merciful, the Especially Merciful.',
            source: 'Sahih International Translation',
          ),
        ],
        juz: 1,
        hizb: 1,
        rub: 1,
        tafsir: 'The Most Gracious, the Most Merciful. These two names of Allah emphasize His infinite mercy and compassion towards all of His creation. Ar-Rahman refers to Allah\'s mercy that encompasses all creation, while Ar-Raheem refers to His special mercy for the believers.',
      ),
      Ayah(
        surahNumber: 1,
        ayahNumber: 4,
        arabicText: 'مَالِكِ يَوْمِ الدِّينِ',
        words: [
          const Word(
            arabic: 'مَالِكِ',
            transliteration: 'Maliki',
            root: 'م ل ك',
            meaning: 'Master',
            contextualMeaning: 'Master and Owner',
            position: 1,
            relatedWords: ['ملك', 'ملكوت'],
            partOfSpeech: 'noun',
            grammar: 'genitive',
          ),
          const Word(
            arabic: 'يَوْمِ',
            transliteration: 'yawmi',
            root: 'ي و م',
            meaning: 'day',
            contextualMeaning: 'the day',
            position: 2,
            relatedWords: ['يوم', 'أيام'],
            partOfSpeech: 'noun',
            grammar: 'genitive',
          ),
          const Word(
            arabic: 'الدِّينِ',
            transliteration: 'ad-deen',
            root: 'د ي ن',
            meaning: 'religion/judgment',
            contextualMeaning: 'the Day of Judgment',
            position: 3,
            relatedWords: ['دين', 'مدين'],
            partOfSpeech: 'noun',
            grammar: 'genitive',
          ),
        ],
        translations: [
          const Translation(
            translator: 'Sahih International',
            language: 'English',
            text: 'Sovereign of the Day of Recompense.',
            source: 'Sahih International Translation',
          ),
        ],
        juz: 1,
        hizb: 1,
        rub: 1,
        tafsir: 'Master of the Day of Judgment. This verse reminds us of the Day of Resurrection when all deeds will be accounted for and justice will be served. It emphasizes Allah\'s absolute authority over the Day of Judgment and serves as a reminder for believers to be conscious of their actions and prepare for the Hereafter.',
      ),
    ];
  }

  // Get mock ayahs (fallback method for compatibility)
  static List<Ayah> getMockAyahs() {
    return _getFallbackAyahs();
  }

  // Generate mock ayahs for any surah number
  static Future<List<Ayah>> _getMockAyahsForSurah(int surahNumber) async {
    // Get surah info from the complete surah list
    final surahs = await getMockSurahs();
    final surah = surahs.firstWhere(
      (s) => s.number == surahNumber,
      orElse: () => const Surah(
        number: 1,
        nameArabic: 'الفاتحة',
        nameEnglish: 'Al-Fatihah',
        nameTransliterated: 'Al-Fatihah',
        ayahCount: 7,
        revelationType: 'Meccan',
        revelationOrder: 5,
      ),
    );

    // Generate mock ayahs based on the surah's ayah count
    List<Ayah> mockAyahs = [];
    for (int i = 1; i <= surah.ayahCount; i++) {
      mockAyahs.add(Ayah(
        surahNumber: surahNumber,
        ayahNumber: i,
        arabicText: 'مثال على النص العربي للآية $i من سورة ${surah.nameArabic}',
        words: [
          Word(
            arabic: 'مثال',
            transliteration: 'mithal',
            root: 'م ث ل',
            meaning: 'example',
            contextualMeaning: 'example word',
            position: 1,
            relatedWords: ['مثيل', 'تمثيل'],
            partOfSpeech: 'noun',
            grammar: 'nominative',
          ),
        ],
        translations: [
          Translation(
            translator: 'Sahih International',
            language: 'English',
            text: 'Example translation for Ayah $i of Surah ${surah.nameEnglish} - This is placeholder text until real data is loaded.',
            source: 'Sahih International Translation',
          ),
          Translation(
            translator: 'Yusuf Ali',
            language: 'English',
            text: 'Example translation for Ayah $i of Surah ${surah.nameEnglish} - Yusuf Ali translation placeholder.',
            source: 'The Holy Quran: Text, Translation and Commentary',
          ),
          Translation(
            translator: 'Dr. Mustafa Khattab',
            language: 'English',
            text: 'Example translation for Ayah $i of Surah ${surah.nameEnglish} - Clear Quran translation placeholder.',
            source: 'The Clear Quran',
          ),
        ],
        juz: _calculateJuz(surahNumber, i),
        hizb: _calculateHizb(surahNumber, i),
        rub: _calculateRub(surahNumber, i),
        tafsir: _getTafsirForAyah(surahNumber, i),
      ));
    }
    return mockAyahs;
  }

  // Calculate Juz based on surah and ayah number
  static int _calculateJuz(int surahNumber, int ayahNumber) {
    // Simplified Juz calculation based on traditional divisions
    if (surahNumber == 1) return 1;
    if (surahNumber == 2 && ayahNumber <= 141) return 1;
    if (surahNumber == 2 && ayahNumber <= 252) return 2;
    if (surahNumber == 2 && ayahNumber <= 286) return 3;
    if (surahNumber == 3 && ayahNumber <= 92) return 3;
    if (surahNumber == 3 && ayahNumber <= 200) return 4;
    if (surahNumber == 4 && ayahNumber <= 23) return 4;
    if (surahNumber == 4 && ayahNumber <= 87) return 5;
    if (surahNumber == 4 && ayahNumber <= 176) return 6;
    if (surahNumber == 5 && ayahNumber <= 120) return 6;
    if (surahNumber == 6 && ayahNumber <= 110) return 7;
    if (surahNumber == 6 && ayahNumber <= 165) return 8;
    if (surahNumber == 7 && ayahNumber <= 87) return 8;
    if (surahNumber == 7 && ayahNumber <= 206) return 9;
    if (surahNumber == 8 && ayahNumber <= 75) return 9;
    if (surahNumber == 9 && ayahNumber <= 93) return 10;
    if (surahNumber == 9 && ayahNumber <= 129) return 11;
    if (surahNumber == 10 && ayahNumber <= 109) return 11;
    if (surahNumber == 11 && ayahNumber <= 123) return 12;
    if (surahNumber == 12 && ayahNumber <= 111) return 12;
    if (surahNumber == 13 && ayahNumber <= 43) return 13;
    if (surahNumber == 14 && ayahNumber <= 52) return 13;
    if (surahNumber == 15 && ayahNumber <= 99) return 14;
    if (surahNumber == 16 && ayahNumber <= 128) return 14;
    if (surahNumber == 17 && ayahNumber <= 111) return 15;
    if (surahNumber == 18 && ayahNumber <= 110) return 15;
    if (surahNumber == 19 && ayahNumber <= 98) return 16;
    if (surahNumber == 20 && ayahNumber <= 135) return 16;
    if (surahNumber == 21 && ayahNumber <= 112) return 17;
    if (surahNumber == 22 && ayahNumber <= 78) return 17;
    if (surahNumber == 23 && ayahNumber <= 118) return 18;
    if (surahNumber == 24 && ayahNumber <= 64) return 18;
    if (surahNumber == 25 && ayahNumber <= 77) return 19;
    if (surahNumber == 26 && ayahNumber <= 227) return 19;
    if (surahNumber == 27 && ayahNumber <= 93) return 20;
    if (surahNumber == 28 && ayahNumber <= 88) return 20;
    if (surahNumber == 29 && ayahNumber <= 69) return 21;
    if (surahNumber == 30 && ayahNumber <= 60) return 21;
    if (surahNumber == 31 && ayahNumber <= 34) return 21;
    if (surahNumber == 32 && ayahNumber <= 30) return 21;
    if (surahNumber == 33 && ayahNumber <= 73) return 22;
    if (surahNumber == 34 && ayahNumber <= 54) return 22;
    if (surahNumber == 35 && ayahNumber <= 45) return 22;
    if (surahNumber == 36 && ayahNumber <= 83) return 23;
    if (surahNumber == 37 && ayahNumber <= 182) return 23;
    if (surahNumber == 38 && ayahNumber <= 88) return 23;
    if (surahNumber == 39 && ayahNumber <= 75) return 24;
    if (surahNumber == 40 && ayahNumber <= 85) return 24;
    if (surahNumber == 41 && ayahNumber <= 54) return 24;
    if (surahNumber == 42 && ayahNumber <= 53) return 25;
    if (surahNumber == 43 && ayahNumber <= 89) return 25;
    if (surahNumber == 44 && ayahNumber <= 59) return 25;
    if (surahNumber == 45 && ayahNumber <= 37) return 25;
    if (surahNumber == 46 && ayahNumber <= 35) return 26;
    if (surahNumber == 47 && ayahNumber <= 38) return 26;
    if (surahNumber == 48 && ayahNumber <= 29) return 26;
    if (surahNumber == 49 && ayahNumber <= 18) return 26;
    if (surahNumber == 50 && ayahNumber <= 45) return 26;
    if (surahNumber == 51 && ayahNumber <= 60) return 27;
    if (surahNumber == 52 && ayahNumber <= 49) return 27;
    if (surahNumber == 53 && ayahNumber <= 62) return 27;
    if (surahNumber == 54 && ayahNumber <= 55) return 27;
    if (surahNumber == 55 && ayahNumber <= 78) return 27;
    if (surahNumber == 56 && ayahNumber <= 96) return 27;
    if (surahNumber == 57 && ayahNumber <= 29) return 28;
    if (surahNumber == 58 && ayahNumber <= 22) return 28;
    if (surahNumber == 59 && ayahNumber <= 24) return 28;
    if (surahNumber == 60 && ayahNumber <= 13) return 28;
    if (surahNumber == 61 && ayahNumber <= 14) return 28;
    if (surahNumber == 62 && ayahNumber <= 11) return 28;
    if (surahNumber == 63 && ayahNumber <= 11) return 28;
    if (surahNumber == 64 && ayahNumber <= 18) return 28;
    if (surahNumber == 65 && ayahNumber <= 12) return 28;
    if (surahNumber == 66 && ayahNumber <= 12) return 28;
    if (surahNumber == 67 && ayahNumber <= 30) return 29;
    if (surahNumber == 68 && ayahNumber <= 52) return 29;
    if (surahNumber == 69 && ayahNumber <= 52) return 29;
    if (surahNumber == 70 && ayahNumber <= 44) return 29;
    if (surahNumber == 71 && ayahNumber <= 28) return 29;
    if (surahNumber == 72 && ayahNumber <= 28) return 29;
    if (surahNumber == 73 && ayahNumber <= 20) return 29;
    if (surahNumber == 74 && ayahNumber <= 56) return 29;
    if (surahNumber == 75 && ayahNumber <= 40) return 29;
    if (surahNumber == 76 && ayahNumber <= 31) return 29;
    if (surahNumber == 77 && ayahNumber <= 50) return 29;
    if (surahNumber == 78 && ayahNumber <= 40) return 30;
    if (surahNumber == 79 && ayahNumber <= 46) return 30;
    if (surahNumber == 80 && ayahNumber <= 42) return 30;
    if (surahNumber == 81 && ayahNumber <= 29) return 30;
    if (surahNumber == 82 && ayahNumber <= 19) return 30;
    if (surahNumber == 83 && ayahNumber <= 36) return 30;
    if (surahNumber == 84 && ayahNumber <= 25) return 30;
    if (surahNumber == 85 && ayahNumber <= 22) return 30;
    if (surahNumber == 86 && ayahNumber <= 17) return 30;
    if (surahNumber == 87 && ayahNumber <= 19) return 30;
    if (surahNumber == 88 && ayahNumber <= 26) return 30;
    if (surahNumber == 89 && ayahNumber <= 30) return 30;
    if (surahNumber == 90 && ayahNumber <= 20) return 30;
    if (surahNumber == 91 && ayahNumber <= 15) return 30;
    if (surahNumber == 92 && ayahNumber <= 21) return 30;
    if (surahNumber == 93 && ayahNumber <= 11) return 30;
    if (surahNumber == 94 && ayahNumber <= 8) return 30;
    if (surahNumber == 95 && ayahNumber <= 8) return 30;
    if (surahNumber == 96 && ayahNumber <= 19) return 30;
    if (surahNumber == 97 && ayahNumber <= 5) return 30;
    if (surahNumber == 98 && ayahNumber <= 8) return 30;
    if (surahNumber == 99 && ayahNumber <= 8) return 30;
    if (surahNumber == 100 && ayahNumber <= 11) return 30;
    if (surahNumber == 101 && ayahNumber <= 11) return 30;
    if (surahNumber == 102 && ayahNumber <= 8) return 30;
    if (surahNumber == 103 && ayahNumber <= 3) return 30;
    if (surahNumber == 104 && ayahNumber <= 9) return 30;
    if (surahNumber == 105 && ayahNumber <= 5) return 30;
    if (surahNumber == 106 && ayahNumber <= 4) return 30;
    if (surahNumber == 107 && ayahNumber <= 7) return 30;
    if (surahNumber == 108 && ayahNumber <= 3) return 30;
    if (surahNumber == 109 && ayahNumber <= 6) return 30;
    if (surahNumber == 110 && ayahNumber <= 3) return 30;
    if (surahNumber == 111 && ayahNumber <= 5) return 30;
    if (surahNumber == 112 && ayahNumber <= 4) return 30;
    if (surahNumber == 113 && ayahNumber <= 5) return 30;
    if (surahNumber == 114 && ayahNumber <= 6) return 30;
    
    return 30; // Default to last Juz
  }

  // Calculate Hizb based on surah and ayah number
  static int _calculateHizb(int surahNumber, int ayahNumber) {
    // Simplified Hizb calculation (60 hizbs total)
    return ((ayahNumber - 1) ~/ 20) + 1;
  }

  // Calculate Rub based on surah and ayah number
  static int _calculateRub(int surahNumber, int ayahNumber) {
    // Simplified Rub calculation (240 rubs total)
    return ((ayahNumber - 1) ~/ 5) + 1;
  }

  // Get tafsir for a specific ayah
  static String _getTafsirForAyah(int surahNumber, int ayahNumber) {
    // Sample tafsir data for different surahs and ayahs
    final tafsirData = {
      '1_1': 'This verse begins with the name of Allah, the Most Gracious, the Most Merciful. It establishes the foundation of Islamic belief in the oneness of Allah and His attributes of mercy and grace.',
      '1_2': 'All praise is due to Allah, the Lord of all the worlds. This verse teaches us to acknowledge Allah\'s sovereignty over all creation and to express gratitude for His countless blessings.',
      '1_3': 'The Most Gracious, the Most Merciful. These two names of Allah emphasize His infinite mercy and compassion towards all of His creation.',
      '1_4': 'Master of the Day of Judgment. This verse reminds us of the Day of Resurrection when all deeds will be accounted for and justice will be served.',
      '1_5': 'It is You we worship and You we ask for help. This verse establishes the relationship between the servant and Allah, emphasizing worship and seeking divine assistance.',
      '1_6': 'Guide us to the straight path. This is a prayer for guidance to the path of righteousness and truth.',
      '1_7': 'The path of those upon whom You have bestowed favor, not of those who have evoked [Your] anger or of those who are astray. This verse clarifies the straight path as the path of the righteous.',
      '2_1': 'Alif, Lam, Mim. These are mysterious letters (huruf muqatta\'at) that appear at the beginning of certain surahs. Their exact meaning is known only to Allah.',
      '2_2': 'This is the Book about which there is no doubt, a guidance for those conscious of Allah. The Quran is described as a clear guidance for those who are mindful of Allah.',
      '2_3': 'Who believe in the unseen, establish prayer, and spend out of what We have provided for them. This verse describes the characteristics of the righteous believers.',
    };

    final key = '${surahNumber}_$ayahNumber';
    return tafsirData[key] ?? 'This ayah contains important guidance and wisdom. The tafsir (commentary) provides deeper understanding of the meanings and context of this verse. It is recommended to study this ayah with qualified scholars to gain comprehensive understanding of its implications and applications in daily life.';
  }

  // Mock Prayer Times data
  static Map<String, String> getMockPrayerTimes() {
    return {
      'Fajr': '5:30 AM',
      'Dhuhr': '12:15 PM',
      'Asr': '3:45 PM',
      'Maghrib': '6:20 PM',
      'Isha': '7:45 PM',
    };
  }

  // ===== COMPREHENSIVE MOCK DATA FOR ALL MODULES =====

  // Mock Prayer Times Data
  static List<Map<String, dynamic>> getMockPrayerTimesData() {
    return [
      {
        'fajr': '2024-01-15T05:30:00',
        'sunrise': '2024-01-15T07:00:00',
        'dhuhr': '2024-01-15T12:15:00',
        'asr': '2024-01-15T15:45:00',
        'maghrib': '2024-01-15T18:20:00',
        'isha': '2024-01-15T19:45:00',
        'calculationMethod': 'Umm al-Qura',
        'timezone': 'Asia/Riyadh',
      },
      {
        'fajr': '2024-01-15T05:45:00',
        'sunrise': '2024-01-15T07:15:00',
        'dhuhr': '2024-01-15T12:30:00',
        'asr': '2024-01-15T16:00:00',
        'maghrib': '2024-01-15T18:35:00',
        'isha': '2024-01-15T20:00:00',
        'calculationMethod': 'Islamic Society of North America',
        'timezone': 'America/New_York',
      },
    ];
  }

  // Mock Location Data
  static List<Map<String, dynamic>> getMockLocations() {
    return [
      {
        'latitude': 24.7136,
        'longitude': 46.6753,
        'city': 'Riyadh',
        'country': 'Saudi Arabia',
        'timezone': 'Asia/Riyadh',
        'state': 'Riyadh Province',
        'countryCode': 'SA',
      },
      {
        'latitude': 25.2048,
        'longitude': 55.2708,
        'city': 'Dubai',
        'country': 'United Arab Emirates',
        'timezone': 'Asia/Dubai',
        'state': 'Dubai',
        'countryCode': 'AE',
      },
      {
        'latitude': 40.7128,
        'longitude': -74.0060,
        'city': 'New York',
        'country': 'United States',
        'timezone': 'America/New_York',
        'state': 'New York',
        'countryCode': 'US',
      },
      {
        'latitude': 51.5074,
        'longitude': -0.1278,
        'city': 'London',
        'country': 'United Kingdom',
        'timezone': 'Europe/London',
        'state': 'England',
        'countryCode': 'GB',
      },
    ];
  }

  // Mock Hadith Data
  static List<Map<String, dynamic>> getMockHadiths() {
    return [
      {
        'id': 'bukhari_1',
        'collection': 'Sahih Bukhari',
        'book': 'Book of Revelation',
        'chapter': 'How the Divine Inspiration started',
        'narrator': 'Aisha (may Allah be pleased with her)',
        'textArabic': 'إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ، وَإِنَّمَا لِكُلِّ امْرِئٍ مَا نَوَى',
        'textEnglish': 'Actions are according to intentions, and everyone will get what was intended.',
        'grade': 'Sahih',
        'tags': ['intention', 'actions', 'niyyah'],
        'reference': 'Sahih Bukhari 1',
      },
      {
        'id': 'muslim_1',
        'collection': 'Sahih Muslim',
        'book': 'Book of Faith',
        'chapter': 'The Book of Faith',
        'narrator': 'Umar ibn al-Khattab (may Allah be pleased with him)',
        'textArabic': 'بُنِيَ الإِسْلاَمُ عَلَى خَمْسٍ: شَهَادَةِ أَنْ لاَ إِلَهَ إِلاَّ اللَّهُ وَأَنَّ مُحَمَّدًا رَسُولُ اللَّهِ، وَإِقَامِ الصَّلاَةِ، وَإِيتَاءِ الزَّكَاةِ، وَالْحَجِّ، وَصَوْمِ رَمَضَانَ',
        'textEnglish': 'Islam is built upon five pillars: testifying that there is no god but Allah and that Muhammad ﷺ is the Messenger of Allah, establishing prayer, giving zakah, performing Hajj, and fasting in Ramadan.',
        'grade': 'Sahih',
        'tags': ['pillars', 'islam', 'foundation'],
        'reference': 'Sahih Muslim 16',
      },
      {
        'id': 'bukhari_2',
        'collection': 'Sahih Bukhari',
        'book': 'Book of Belief',
        'chapter': 'The Book of Belief',
        'narrator': 'Abu Huraira (may Allah be pleased with him)',
        'textArabic': 'مَنْ كَانَ يُؤْمِنُ بِاللَّهِ وَالْيَوْمِ الآخِرِ فَلْيَقُلْ خَيْرًا أَوْ لِيَصْمُتْ',
        'textEnglish': 'Whoever believes in Allah and the Last Day should speak good or remain silent.',
        'grade': 'Sahih',
        'tags': ['speech', 'silence', 'good words'],
        'reference': 'Sahih Bukhari 6018',
      },
    ];
  }

  // Mock Supplications Data
  static List<Map<String, dynamic>> getMockSupplications() {
    return [
      {
        'id': 'morning_1',
        'title': 'Morning Remembrance',
        'arabicText': 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ',
        'englishText': 'We have reached the morning and at this very time all sovereignty belongs to Allah, and all praise is for Allah. None has the right to be worshipped except Allah, alone, without partner.',
        'transliteration': 'Asbahna wa asbahal mulku lillah, wal hamdu lillah, la ilaha illa Allah wahdahu la sharika lah',
        'category': 'Morning Adhkar',
        'context': 'Upon waking up',
        'audioUrl': 'https://example.com/audio/morning_1.mp3',
        'repetition': 1,
        'benefits': ['Protection from harm', 'Blessings for the day', 'Remembrance of Allah'],
        'reference': 'Sunan Abu Dawood 5074',
      },
      {
        'id': 'evening_1',
        'title': 'Evening Remembrance',
        'arabicText': 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ',
        'englishText': 'We have reached the evening and at this very time all sovereignty belongs to Allah, and all praise is for Allah. None has the right to be worshipped except Allah, alone, without partner.',
        'transliteration': 'Amsayna wa amsal mulku lillah, wal hamdu lillah, la ilaha illa Allah wahdahu la sharika lah',
        'category': 'Evening Adhkar',
        'context': 'In the evening',
        'audioUrl': 'https://example.com/audio/evening_1.mp3',
        'repetition': 1,
        'benefits': ['Protection from harm', 'Blessings for the night', 'Remembrance of Allah'],
        'reference': 'Sunan Abu Dawood 5074',
      },
      {
        'id': 'prayer_1',
        'title': 'Before Prayer',
        'arabicText': 'اللَّهُمَّ بَاعِدْ بَيْنِي وَبَيْنَ خَطَايَايَ كَمَا بَاعَدْتَ بَيْنَ الْمَشْرِقِ وَالْمَغْرِبِ',
        'englishText': 'O Allah, distance me from my sins just as You have distanced the East from the West.',
        'transliteration': 'Allahumma ba\'id bayni wa bayna khatayaya kama ba\'adta baynal mashriqi wal maghrib',
        'category': 'Prayer Supplications',
        'context': 'Before starting prayer',
        'audioUrl': 'https://example.com/audio/prayer_1.mp3',
        'repetition': 1,
        'benefits': ['Forgiveness of sins', 'Purification', 'Spiritual preparation'],
        'reference': 'Sahih Bukhari 744',
      },
    ];
  }

  // Mock Islamic Calendar Data
  static List<Map<String, dynamic>> getMockIslamicEvents() {
    return [
      {
        'id': 'ramadan_2024',
        'name': 'Ramadan',
        'description': 'The holy month of fasting, prayer, and reflection',
        'date': '2024-03-10T00:00:00',
        'type': 'religious',
        'importance': 'high',
        'traditions': ['Fasting from dawn to sunset', 'Increased prayer and recitation', 'Charity and good deeds'],
      },
      {
        'id': 'eid_al_fitr_2024',
        'name': 'Eid al-Fitr',
        'description': 'Festival of Breaking the Fast',
        'date': '2024-04-09T00:00:00',
        'type': 'religious',
        'importance': 'high',
        'traditions': ['Eid prayer', 'Giving charity (Zakat al-Fitr)', 'Celebration with family and friends'],
      },
      {
        'id': 'hajj_2024',
        'name': 'Hajj',
        'description': 'Annual pilgrimage to Mecca',
        'date': '2024-06-14T00:00:00',
        'type': 'religious',
        'importance': 'high',
        'traditions': ['Pilgrimage to Mecca', 'Circumambulation of Kaaba', 'Standing at Arafat'],
      },
    ];
  }

  // Mock Reciters Data
  static List<Map<String, dynamic>> getMockReciters() {
    return [
      {
        'id': 'abdul_basit',
        'name': 'Abdul Basit Abdul Samad',
        'nameArabic': 'عبد الباسط عبد الصمد',
        'country': 'Egypt',
        'style': 'murattal',
        'quality': 'high',
        'language': 'Arabic',
        'description': 'One of the most famous Quran reciters in the world',
        'imageUrl': 'https://example.com/images/abdul_basit.jpg',
        'isPopular': true,
        'isRecommended': true,
        'totalRecitations': 114,
        'rating': 4.9,
        'availableFormats': ['mp3', 'ogg'],
        'audioUrls': {
          'mp3': 'https://example.com/audio/abdul_basit/',
          'ogg': 'https://example.com/audio/abdul_basit/ogg/',
        },
      },
      {
        'id': 'mishary_rashid',
        'name': 'Mishary Rashid Alafasy',
        'nameArabic': 'مشاري راشد العفاسي',
        'country': 'Kuwait',
        'style': 'murattal',
        'quality': 'high',
        'language': 'Arabic',
        'description': 'Contemporary reciter known for his beautiful voice',
        'imageUrl': 'https://example.com/images/mishary_rashid.jpg',
        'isPopular': true,
        'isRecommended': true,
        'totalRecitations': 114,
        'rating': 4.8,
        'availableFormats': ['mp3', 'ogg', 'wav'],
        'audioUrls': {
          'mp3': 'https://example.com/audio/mishary_rashid/',
          'ogg': 'https://example.com/audio/mishary_rashid/ogg/',
          'wav': 'https://example.com/audio/mishary_rashid/wav/',
        },
      },
    ];
  }

  // Mock Settings Data
  static Map<String, dynamic> getDefaultAppSettings() {
    return {
      'language': 'en',
      'theme': 'system',
      'useDynamicColors': true,
      'primaryColor': 'blue',
      'secondaryColor': 'green',
      'tertiaryColor': 'orange',
      'fontSize': 16.0,
      'fontFamily': 'Roboto',
      'rtlSupport': true,
      'hapticFeedback': true,
      'soundEffects': true,
      'dateFormat': 'MM/dd/yyyy',
      'timeFormat': '12h',
      'notificationsEnabled': true,
      'autoUpdate': true,
      'offlineMode': false,
      'defaultTranslation': 'Sahih International',
      'defaultTafsir': 'Ibn Kathir',
      'defaultReciter': 'Abdul Basit Abdul Samad',
      'showTransliteration': true,
      'showWordMeaning': true,
      'showRootWords': true,
      'showContextualMeaning': true,
      'enableBookmarks': true,
      'enableNotes': true,
      'enableStudySessions': true,
      'enableProgressTracking': true,
    };
  }

  // Mock Bookmark Data
  static List<Map<String, dynamic>> getMockBookmarks() {
    return [
      {
        'id': 'bookmark_1',
        'surahNumber': 1,
        'ayahNumber': 1,
        'surahName': 'Al-Fatihah',
        'ayahText': 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        'createdAt': '2024-01-15T10:30:00',
        'note': 'Beautiful opening verse',
        'tags': ['favorite', 'opening'],
        'type': 'ayah',
      },
      {
        'id': 'bookmark_2',
        'surahNumber': 2,
        'ayahNumber': 255,
        'surahName': 'Al-Baqarah',
        'ayahText': 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ',
        'createdAt': '2024-01-15T11:00:00',
        'note': 'Ayat al-Kursi - The Throne Verse',
        'tags': ['protection', 'throne', 'powerful'],
        'type': 'ayah',
      },
    ];
  }
}
