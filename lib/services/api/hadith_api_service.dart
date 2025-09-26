import 'base_api_service.dart';
import '../../models/hadith_models.dart';

/// API service for Hadith-related data
class HadithApiService extends BaseApiService {
  
  /// Get all available Hadith collections
  Future<List<HadithCollection>> getHadithCollections() async {
    try {
      final response = await get<Map<String, dynamic>>(
        '/books',
        cacheExpiration: const Duration(days: 30),
        cacheKey: 'hadith_collections',
      );
      
      if (response['data'] != null) {
        final List<dynamic> collectionsData = response['data'];
        return collectionsData.map((json) => _hadithCollectionFromJson(json)).toList();
      }
      
      throw Exception('No hadith collections data received');
    } catch (e) {
      // Fallback to mock data
      return _getFallbackCollections();
    }
  }
  
  /// Get hadiths from a specific collection
  Future<List<Hadith>> getHadithsFromCollection(String collectionId, {int? page, int? limit}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;
      
      final response = await get<Map<String, dynamic>>(
        '/books/$collectionId',
        queryParameters: queryParams,
        cacheExpiration: const Duration(hours: 12),
        cacheKey: 'hadiths_${collectionId}_${page ?? 1}_${limit ?? 20}',
      );
      
      if (response['data'] != null && response['data']['hadiths'] != null) {
        final List<dynamic> hadithsData = response['data']['hadiths'];
        return hadithsData.map((json) => Hadith.fromJson(json)).toList();
      }
      
      throw Exception('No hadiths data received');
    } catch (e) {
      // Fallback to mock data
      return _getFallbackHadiths();
    }
  }
  
  /// Get specific hadith by collection and hadith number
  Future<Hadith> getHadith(String collectionId, int hadithNumber) async {
    try {
      final response = await get<Map<String, dynamic>>(
        '/books/$collectionId/$hadithNumber',
        cacheExpiration: const Duration(days: 7),
        cacheKey: 'hadith_${collectionId}_$hadithNumber',
      );
      
      if (response['data'] != null) {
        return Hadith.fromJson(response['data']);
      }
      
      throw Exception('No hadith data received');
    } catch (e) {
      // Fallback to mock data
      final hadiths = _getFallbackHadiths();
      return hadiths.first;
    }
  }
  
  /// Search hadiths by text
  Future<List<Hadith>> searchHadiths(String query, {String? collectionId}) async {
    try {
      final endpoint = collectionId != null 
          ? '/search?q=$query&book=$collectionId'
          : '/search?q=$query';
          
      final response = await get<Map<String, dynamic>>(
        endpoint,
        cacheExpiration: const Duration(hours: 6),
        cacheKey: 'hadith_search_${query}_$collectionId',
      );
      
      if (response['data'] != null && response['data']['hadiths'] != null) {
        final List<dynamic> hadithsData = response['data']['hadiths'];
        return hadithsData.map((json) => Hadith.fromJson(json)).toList();
      }
      
      return [];
    } catch (e) {
      // Return empty list if search fails
      return [];
    }
  }
  
  /// Get hadiths by narrator
  Future<List<Hadith>> getHadithsByNarrator(String narratorName) async {
    try {
      final response = await get<Map<String, dynamic>>(
        '/search?narrator=$narratorName',
        cacheExpiration: const Duration(hours: 12),
        cacheKey: 'hadiths_narrator_$narratorName',
      );
      
      if (response['data'] != null && response['data']['hadiths'] != null) {
        final List<dynamic> hadithsData = response['data']['hadiths'];
        return hadithsData.map((json) => Hadith.fromJson(json)).toList();
      }
      
      return [];
    } catch (e) {
      // Return empty list if search fails
      return [];
    }
  }
  
  /// Get hadiths by grade/authenticity
  Future<List<Hadith>> getHadithsByGrade(String grade) async {
    try {
      final response = await get<Map<String, dynamic>>(
        '/search?grade=$grade',
        cacheExpiration: const Duration(hours: 12),
        cacheKey: 'hadiths_grade_$grade',
      );
      
      if (response['data'] != null && response['data']['hadiths'] != null) {
        final List<dynamic> hadithsData = response['data']['hadiths'];
        return hadithsData.map((json) => Hadith.fromJson(json)).toList();
      }
      
      return [];
    } catch (e) {
      // Return empty list if search fails
      return [];
    }
  }
  
  /// Get random hadith
  Future<Hadith> getRandomHadith({String? collectionId}) async {
    try {
      final endpoint = collectionId != null 
          ? '/random?book=$collectionId'
          : '/random';
          
      final response = await get<Map<String, dynamic>>(
        endpoint,
        cacheExpiration: const Duration(minutes: 30),
        cacheKey: 'random_hadith_$collectionId',
      );
      
      if (response['data'] != null) {
        return Hadith.fromJson(response['data']);
      }
      
      throw Exception('No random hadith data received');
    } catch (e) {
      // Fallback to mock data
      final hadiths = _getFallbackHadiths();
      return hadiths.first;
    }
  }
  
  /// Get hadith categories/topics
  Future<List<Map<String, dynamic>>> getHadithCategories() async {
    try {
      final response = await get<Map<String, dynamic>>(
        '/categories',
        cacheExpiration: const Duration(days: 30),
        cacheKey: 'hadith_categories',
      );
      
      if (response['data'] != null) {
        return List<Map<String, dynamic>>.from(response['data']);
      }
      
      throw Exception('No categories data received');
    } catch (e) {
      // Return default categories
      return _getDefaultCategories();
    }
  }
  
  /// Get hadiths by category
  Future<List<Hadith>> getHadithsByCategory(String categoryId) async {
    try {
      final response = await get<Map<String, dynamic>>(
        '/categories/$categoryId',
        cacheExpiration: const Duration(hours: 12),
        cacheKey: 'hadiths_category_$categoryId',
      );
      
      if (response['data'] != null && response['data']['hadiths'] != null) {
        final List<dynamic> hadithsData = response['data']['hadiths'];
        return hadithsData.map((json) => Hadith.fromJson(json)).toList();
      }
      
      return [];
    } catch (e) {
      // Return empty list if search fails
      return [];
    }
  }
  
  // Fallback methods using mock data
  List<HadithCollection> _getFallbackCollections() {
    return [
      HadithCollection(
        name: 'Sahih Bukhari',
        description: 'The most authentic collection of hadiths',
        author: 'Imam Bukhari',
        totalHadiths: 7563,
        language: 'Arabic',
      ),
      HadithCollection(
        name: 'Sahih Muslim',
        description: 'Second most authentic collection',
        author: 'Imam Muslim',
        totalHadiths: 7563,
        language: 'Arabic',
      ),
      HadithCollection(
        name: 'Sunan Abu Dawood',
        description: 'Collection of hadiths by Abu Dawood',
        author: 'Abu Dawood',
        totalHadiths: 4800,
        language: 'Arabic',
      ),
      HadithCollection(
        name: 'Jami at-Tirmidhi',
        description: 'Collection by Imam Tirmidhi',
        author: 'Imam Tirmidhi',
        totalHadiths: 3956,
        language: 'Arabic',
      ),
      HadithCollection(
        name: 'Sunan an-Nasa\'i',
        description: 'Collection by Imam Nasa\'i',
        author: 'Imam Nasa\'i',
        totalHadiths: 5761,
        language: 'Arabic',
      ),
      HadithCollection(
        name: 'Sunan Ibn Majah',
        description: 'Collection by Ibn Majah',
        author: 'Ibn Majah',
        totalHadiths: 4341,
        language: 'Arabic',
      ),
    ];
  }
  
  List<Hadith> _getFallbackHadiths() {
    return [
      Hadith(
        id: '1',
        collection: 'Sahih Bukhari',
        book: 'Book of Faith',
        chapter: 'Chapter 1',
        narrator: 'Abu Huraira',
        textArabic: 'قَالَ رَسُولُ اللَّهِ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ: "الإِيمَانُ بِضْعٌ وَسَبْعُونَ شُعْبَةً، فَأَفْضَلُهَا قَوْلُ لَا إِلَهَ إِلَّا اللَّهُ، وَأَدْنَاهَا إِمَاطَةُ الْأَذَى عَنِ الطَّرِيقِ، وَالْحَيَاءُ شُعْبَةٌ مِنَ الْإِيمَانِ"',
        textEnglish: 'The Messenger of Allah (peace be upon him) said: "Faith has over seventy branches, and the most excellent of them is the declaration that there is no god but Allah, and the lowest of them is the removal of what is injurious from the path, and modesty is a branch of faith."',
        grade: 'Sahih',
        tags: ['Faith', 'Modesty', 'Good Deeds'],
        reference: 'Sahih Bukhari 9',
      ),
      Hadith(
        id: '2',
        collection: 'Sahih Muslim',
        book: 'Book of Prayer',
        chapter: 'Chapter 1',
        narrator: 'Ibn Umar',
        textArabic: 'قَالَ رَسُولُ اللَّهِ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ: "بُنِيَ الْإِسْلَامُ عَلَى خَمْسٍ: شَهَادَةِ أَنْ لَا إِلَهَ إِلَّا اللَّهُ وَأَنَّ مُحَمَّدًا رَسُولُ اللَّهِ، وَإِقَامِ الصَّلَاةِ، وَإِيتَاءِ الزَّكَاةِ، وَالْحَجِّ، وَصَوْمِ رَمَضَانَ"',
        textEnglish: 'The Messenger of Allah (peace be upon him) said: "Islam is built upon five pillars: testifying that there is no god but Allah and that Muhammad ﷺ is the Messenger of Allah, establishing prayer, giving zakah, performing Hajj, and fasting in Ramadan."',
        grade: 'Sahih',
        tags: ['Islam', 'Pillars', 'Prayer', 'Zakah', 'Hajj', 'Fasting'],
        reference: 'Sahih Muslim 16',
      ),
    ];
  }
  
  List<Map<String, dynamic>> _getDefaultCategories() {
    return [
      {
        'id': 'faith',
        'name': 'Faith (Iman)',
        'description': 'Hadiths about faith and belief',
        'count': 150,
      },
      {
        'id': 'prayer',
        'name': 'Prayer (Salah)',
        'description': 'Hadiths about prayer and worship',
        'count': 200,
      },
      {
        'id': 'charity',
        'name': 'Charity (Zakah)',
        'description': 'Hadiths about charity and giving',
        'count': 100,
      },
      {
        'id': 'fasting',
        'name': 'Fasting (Sawm)',
        'description': 'Hadiths about fasting and Ramadan',
        'count': 80,
      },
      {
        'id': 'pilgrimage',
        'name': 'Pilgrimage (Hajj)',
        'description': 'Hadiths about Hajj and Umrah',
        'count': 120,
      },
      {
        'id': 'manners',
        'name': 'Good Manners',
        'description': 'Hadiths about good character and manners',
        'count': 300,
      },
    ];
  }
  
  // Helper method to create HadithCollection from JSON
  HadithCollection _hadithCollectionFromJson(Map<String, dynamic> json) {
    return HadithCollection(
      name: json['name'] ?? 'Unknown',
      description: json['description'] ?? '',
      author: json['author'] ?? 'Unknown',
      totalHadiths: json['totalHadiths'] ?? 0,
      language: json['language'] ?? 'Arabic',
    );
  }
}
