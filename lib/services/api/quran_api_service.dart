import 'base_api_service.dart';
import '../../models/quran_models.dart';

/// API service for Quran-related data
class QuranApiService extends BaseApiService {
  
  /// Get all surahs
  Future<List<Surah>> getSurahs() async {
    try {
      final response = await get<Map<String, dynamic>>(
        '/surah',
        cacheExpiration: const Duration(days: 30), // Surahs don't change
        cacheKey: 'quran_surahs',
      );
      
      if (response['data'] != null) {
        final List<dynamic> surahsData = response['data'];
        return surahsData.map((json) => Surah.fromJson(json)).toList();
      }
      
      throw Exception('No surah data received');
    } catch (e) {
      // Fallback to mock data if API fails
      return await _getFallbackSurahs();
    }
  }
  
  /// Get specific surah by number
  Future<Surah> getSurah(int surahNumber) async {
    try {
      final response = await get<Map<String, dynamic>>(
        '/surah/$surahNumber',
        cacheExpiration: const Duration(days: 30),
        cacheKey: 'quran_surah_$surahNumber',
      );
      
      if (response['data'] != null) {
        return Surah.fromJson(response['data']);
      }
      
      throw Exception('No surah data received');
    } catch (e) {
      // Fallback to mock data
      final surahs = await _getFallbackSurahs();
      return surahs.firstWhere(
        (s) => s.number == surahNumber,
        orElse: () => surahs.first,
      );
    }
  }
  
  /// Get ayahs for a specific surah
  Future<List<Ayah>> getAyahsForSurah(int surahNumber) async {
    try {
      final response = await get<Map<String, dynamic>>(
        '/surah/$surahNumber',
        cacheExpiration: const Duration(days: 30),
        cacheKey: 'quran_ayahs_$surahNumber',
      );
      
      if (response['data'] != null && response['data']['ayahs'] != null) {
        final List<dynamic> ayahsData = response['data']['ayahs'];
        return ayahsData.map((json) => Ayah.fromJson(json)).toList();
      }
      
      throw Exception('No ayah data received');
    } catch (e) {
      // Fallback to mock data
      return await _getFallbackAyahsForSurah(surahNumber);
    }
  }
  
  /// Get specific ayah by surah and ayah number
  Future<Ayah> getAyah(int surahNumber, int ayahNumber) async {
    try {
      final response = await get<Map<String, dynamic>>(
        '/ayah/$surahNumber:$ayahNumber',
        cacheExpiration: const Duration(days: 30),
        cacheKey: 'quran_ayah_${surahNumber}_$ayahNumber',
      );
      
      if (response['data'] != null) {
        return Ayah.fromJson(response['data']);
      }
      
      throw Exception('No ayah data received');
    } catch (e) {
      // Fallback to mock data
      final ayahs = await _getFallbackAyahsForSurah(surahNumber);
      return ayahs.firstWhere(
        (a) => a.ayahNumber == ayahNumber,
        orElse: () => ayahs.first,
      );
    }
  }
  
  /// Get translations for a surah
  Future<List<Ayah>> getSurahWithTranslation(int surahNumber, String translationId) async {
    try {
      final response = await get<Map<String, dynamic>>(
        '/surah/$surahNumber/$translationId',
        cacheExpiration: const Duration(days: 7),
        cacheKey: 'quran_surah_${surahNumber}_translation_$translationId',
      );
      
      if (response['data'] != null && response['data']['ayahs'] != null) {
        final List<dynamic> ayahsData = response['data']['ayahs'];
        return ayahsData.map((json) => Ayah.fromJson(json)).toList();
      }
      
      throw Exception('No translation data received');
    } catch (e) {
      // Fallback to mock data
      return await _getFallbackAyahsForSurah(surahNumber);
    }
  }
  
  /// Get available translations
  Future<List<Map<String, dynamic>>> getAvailableTranslations() async {
    try {
      final response = await get<Map<String, dynamic>>(
        '/edition/format/translation',
        cacheExpiration: const Duration(days: 30),
        cacheKey: 'quran_translations',
      );
      
      if (response['data'] != null) {
        return List<Map<String, dynamic>>.from(response['data']);
      }
      
      throw Exception('No translations data received');
    } catch (e) {
      // Return default translations
      return _getDefaultTranslations();
    }
  }
  
  /// Get available reciters
  Future<List<Map<String, dynamic>>> getAvailableReciters() async {
    try {
      final response = await get<Map<String, dynamic>>(
        '/edition/format/audio',
        cacheExpiration: const Duration(days: 30),
        cacheKey: 'quran_reciters',
      );
      
      if (response['data'] != null) {
        return List<Map<String, dynamic>>.from(response['data']);
      }
      
      throw Exception('No reciters data received');
    } catch (e) {
      // Return default reciters
      return _getDefaultReciters();
    }
  }
  
  /// Search Quran text
  Future<List<Ayah>> searchQuran(String query, {String? translationId}) async {
    try {
      final endpoint = translationId != null 
          ? '/search/$query/$translationId'
          : '/search/$query';
          
      final response = await get<Map<String, dynamic>>(
        endpoint,
        cacheExpiration: const Duration(hours: 6),
        cacheKey: 'quran_search_${query}_$translationId',
      );
      
      if (response['data'] != null && response['data']['matches'] != null) {
        final List<dynamic> matches = response['data']['matches'];
        return matches.map((json) => Ayah.fromJson(json)).toList();
      }
      
      return [];
    } catch (e) {
      // Return empty list if search fails
      return [];
    }
  }
  
  /// Get Juz (Para) information
  Future<List<Map<String, dynamic>>> getJuzs() async {
    try {
      final response = await get<Map<String, dynamic>>(
        '/juz',
        cacheExpiration: const Duration(days: 30),
        cacheKey: 'quran_juzs',
      );
      
      if (response['data'] != null) {
        return List<Map<String, dynamic>>.from(response['data']);
      }
      
      throw Exception('No Juz data received');
    } catch (e) {
      // Return default Juz data
      return _getDefaultJuzs();
    }
  }
  
  /// Get ayahs for a specific Juz
  Future<List<Ayah>> getAyahsForJuz(int juzNumber) async {
    try {
      final response = await get<Map<String, dynamic>>(
        '/juz/$juzNumber',
        cacheExpiration: const Duration(days: 30),
        cacheKey: 'quran_juz_$juzNumber',
      );
      
      if (response['data'] != null && response['data']['ayahs'] != null) {
        final List<dynamic> ayahsData = response['data']['ayahs'];
        return ayahsData.map((json) => Ayah.fromJson(json)).toList();
      }
      
      throw Exception('No Juz ayah data received');
    } catch (e) {
      // Fallback to mock data
      return await _getFallbackAyahsForJuz(juzNumber);
    }
  }
  
  // Fallback methods using mock data
  Future<List<Surah>> _getFallbackSurahs() async {
    // Use hardcoded fallback data
    return _getDefaultSurahs();
  }
  
  Future<List<Ayah>> _getFallbackAyahsForSurah(int surahNumber) async {
    // Use hardcoded fallback data
    return _getDefaultAyahsForSurah(surahNumber);
  }
  
  Future<List<Ayah>> _getFallbackAyahsForJuz(int juzNumber) async {
    // Generate mock ayahs for Juz
    final List<Ayah> ayahs = [];
    // This would need to be implemented based on Juz boundaries
    return ayahs;
  }
  
  List<Map<String, dynamic>> _getDefaultTranslations() {
    return [
      {
        'identifier': 'en.sahih',
        'language': 'English',
        'name': 'Sahih International',
        'englishName': 'Sahih International',
        'format': 'text',
        'type': 'translation',
      },
      {
        'identifier': 'en.pickthall',
        'language': 'English',
        'name': 'Mohammed Marmaduke William Pickthall',
        'englishName': 'Pickthall',
        'format': 'text',
        'type': 'translation',
      },
      {
        'identifier': 'en.yusufali',
        'language': 'English',
        'name': 'Abdullah Yusuf Ali',
        'englishName': 'Yusuf Ali',
        'format': 'text',
        'type': 'translation',
      },
    ];
  }
  
  List<Map<String, dynamic>> _getDefaultReciters() {
    return [
      {
        'identifier': 'ar.abdulbasitmurattal',
        'language': 'Arabic',
        'name': 'Abdul Basit Murattal',
        'englishName': 'Abdul Basit Murattal',
        'format': 'audio',
        'type': 'versebyverse',
      },
      {
        'identifier': 'ar.abdulbasitmujawwad',
        'language': 'Arabic',
        'name': 'Abdul Basit Mujawwad',
        'englishName': 'Abdul Basit Mujawwad',
        'format': 'audio',
        'type': 'versebyverse',
      },
      {
        'identifier': 'ar.misharyrashidalfasy',
        'language': 'Arabic',
        'name': 'Mishary Rashid Alafasy',
        'englishName': 'Mishary Rashid Alafasy',
        'format': 'audio',
        'type': 'versebyverse',
      },
    ];
  }
  
  List<Map<String, dynamic>> _getDefaultJuzs() {
    return List.generate(30, (index) => {
      'number': index + 1,
      'ayahs': <Map<String, dynamic>>[],
    });
  }
  
  List<Surah> _getDefaultSurahs() {
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
    ];
  }
  
  List<Ayah> _getDefaultAyahsForSurah(int surahNumber) {
    if (surahNumber == 1) {
      return [
        Ayah(
          surahNumber: 1,
          ayahNumber: 1,
          arabicText: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
          words: [],
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
          tafsir: 'This verse begins with the name of Allah, the Most Gracious, the Most Merciful.',
        ),
      ];
    }
    return [];
  }
}
