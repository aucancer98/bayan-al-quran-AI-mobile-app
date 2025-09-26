import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing app data caching and offline support
class CacheService {
  static const String _cachePrefix = 'bayan_al_quran_cache_';
  static const String _lastSyncKey = 'last_sync_timestamp';
  static const String _offlineDataKey = 'offline_data';
  
  late SharedPreferences _prefs;
  
  /// Initialize the cache service
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  /// Cache data with expiration
  Future<void> cacheData(String key, dynamic data, {Duration? expiration}) async {
    try {
      final cacheKey = '$_cachePrefix$key';
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      
      final cacheData = {
        'data': data,
        'timestamp': timestamp,
        'expiration': expiration?.inMilliseconds,
      };
      
      await _prefs.setString(cacheKey, json.encode(cacheData));
    } catch (e) {
      // Cache write failed, continue without caching
    }
  }
  
  /// Get cached data if not expired
  Future<T?> getCachedData<T>(String key) async {
    try {
      final cacheKey = '$_cachePrefix$key';
      final cachedString = _prefs.getString(cacheKey);
      
      if (cachedString != null) {
        final cacheData = json.decode(cachedString) as Map<String, dynamic>;
        final timestamp = cacheData['timestamp'] as int;
        final expiration = cacheData['expiration'] as int?;
        
        // Check if data is expired
        if (expiration != null) {
          final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
          final now = DateTime.now();
          
          if (now.difference(cacheTime).inMilliseconds > expiration) {
            // Data expired, remove it
            await _prefs.remove(cacheKey);
            return null;
          }
        }
        
        return cacheData['data'] as T;
      }
    } catch (e) {
      // Cache read failed
    }
    return null;
  }
  
  /// Check if cached data exists and is valid
  Future<bool> hasValidCache(String key) async {
    final data = await getCachedData(key);
    return data != null;
  }
  
  /// Remove specific cached data
  Future<void> removeCachedData(String key) async {
    try {
      final cacheKey = '$_cachePrefix$key';
      await _prefs.remove(cacheKey);
    } catch (e) {
      // Cache removal failed
    }
  }
  
  /// Clear all cached data
  Future<void> clearAllCache() async {
    try {
      final keys = _prefs.getKeys();
      for (final key in keys) {
        if (key.startsWith(_cachePrefix)) {
          await _prefs.remove(key);
        }
      }
    } catch (e) {
      // Cache clear failed
    }
  }
  
  /// Cache offline data for complete offline support
  Future<void> cacheOfflineData(Map<String, dynamic> data) async {
    try {
      await _prefs.setString(_offlineDataKey, json.encode(data));
      await _prefs.setInt(_lastSyncKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      // Offline data cache failed
    }
  }
  
  /// Get offline data
  Future<Map<String, dynamic>?> getOfflineData() async {
    try {
      final offlineDataString = _prefs.getString(_offlineDataKey);
      if (offlineDataString != null) {
        return json.decode(offlineDataString) as Map<String, dynamic>;
      }
    } catch (e) {
      // Offline data read failed
    }
    return null;
  }
  
  /// Get last sync timestamp
  Future<DateTime?> getLastSyncTime() async {
    try {
      final timestamp = _prefs.getInt(_lastSyncKey);
      if (timestamp != null) {
        return DateTime.fromMillisecondsSinceEpoch(timestamp);
      }
    } catch (e) {
      // Timestamp read failed
    }
    return null;
  }
  
  /// Check if offline data is available
  Future<bool> hasOfflineData() async {
    final data = await getOfflineData();
    return data != null;
  }
  
  /// Get cache size information
  Future<Map<String, dynamic>> getCacheInfo() async {
    try {
      final keys = _prefs.getKeys();
      int cacheCount = 0;
      int totalSize = 0;
      
      for (final key in keys) {
        if (key.startsWith(_cachePrefix)) {
          cacheCount++;
          final value = _prefs.getString(key);
          if (value != null) {
            totalSize += value.length;
          }
        }
      }
      
      return {
        'cacheCount': cacheCount,
        'totalSize': totalSize,
        'totalSizeMB': (totalSize / (1024 * 1024)).toStringAsFixed(2),
        'hasOfflineData': await hasOfflineData(),
        'lastSync': await getLastSyncTime(),
      };
    } catch (e) {
      return {
        'cacheCount': 0,
        'totalSize': 0,
        'totalSizeMB': '0.00',
        'hasOfflineData': false,
        'lastSync': null,
      };
    }
  }
  
  /// Preload essential data for offline use
  Future<void> preloadEssentialData() async {
    try {
      // This would be called during app initialization
      // to cache essential data like surahs, basic hadiths, etc.
      
      final essentialData = {
        'surahs': await _getEssentialSurahs(),
        'hadiths': await _getEssentialHadiths(),
        'prayerTimes': await _getEssentialPrayerTimes(),
        'supplications': await _getEssentialSupplications(),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
      
      await cacheOfflineData(essentialData);
    } catch (e) {
      // Preload failed, continue without offline data
    }
  }
  
  /// Get essential surahs for offline use
  Future<List<Map<String, dynamic>>> _getEssentialSurahs() async {
    // Return basic surah information
    return [
      {
        'number': 1,
        'nameArabic': 'الفاتحة',
        'nameEnglish': 'Al-Fatihah',
        'nameTransliterated': 'Al-Fatihah',
        'ayahCount': 7,
        'revelationType': 'Meccan',
        'revelationOrder': 5,
      },
      {
        'number': 2,
        'nameArabic': 'البقرة',
        'nameEnglish': 'Al-Baqarah',
        'nameTransliterated': 'Al-Baqarah',
        'ayahCount': 286,
        'revelationType': 'Medinan',
        'revelationOrder': 87,
      },
      // Add more essential surahs as needed
    ];
  }
  
  /// Get essential hadiths for offline use
  Future<List<Map<String, dynamic>>> _getEssentialHadiths() async {
    return [
      {
        'id': '1',
        'collection': 'Sahih Bukhari',
        'book': 'Book of Faith',
        'chapter': 'Chapter 1',
        'narrator': 'Abu Huraira',
        'textArabic': 'قَالَ رَسُولُ اللَّهِ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ: "الإِيمَانُ بِضْعٌ وَسَبْعُونَ شُعْبَةً"',
        'textEnglish': 'The Messenger of Allah (peace be upon him) said: "Faith has over seventy branches"',
        'grade': 'Sahih',
        'tags': ['Faith', 'Modesty', 'Good Deeds'],
        'reference': 'Sahih Bukhari 9',
      },
      // Add more essential hadiths as needed
    ];
  }
  
  /// Get essential prayer times for offline use
  Future<Map<String, String>> _getEssentialPrayerTimes() async {
    return {
      'Fajr': '05:30',
      'Dhuhr': '12:15',
      'Asr': '15:45',
      'Maghrib': '18:20',
      'Isha': '19:45',
      'Sunrise': '06:45',
      'Sunset': '18:15',
    };
  }
  
  /// Get essential supplications for offline use
  Future<List<Map<String, dynamic>>> _getEssentialSupplications() async {
    return [
      {
        'id': 'morning_1',
        'title': 'Morning Remembrance',
        'arabicText': 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ',
        'englishText': 'We have reached the morning and at this very time all sovereignty belongs to Allah',
        'transliteration': 'Asbahna wa asbahal mulku lillah',
        'category': 'Morning Adhkar',
        'context': 'Upon waking up',
        'repetition': 1,
      },
      // Add more essential supplications as needed
    ];
  }
  
  /// Export cache data for backup
  Future<Map<String, dynamic>> exportCacheData() async {
    try {
      final keys = _prefs.getKeys();
      final Map<String, dynamic> exportData = {};
      
      for (final key in keys) {
        if (key.startsWith(_cachePrefix)) {
          final value = _prefs.getString(key);
          if (value != null) {
            exportData[key] = value;
          }
        }
      }
      
      return {
        'exportData': exportData,
        'exportTimestamp': DateTime.now().millisecondsSinceEpoch,
        'version': '1.0',
      };
    } catch (e) {
      return {};
    }
  }
  
  /// Import cache data from backup
  Future<bool> importCacheData(Map<String, dynamic> importData) async {
    try {
      if (importData['exportData'] != null) {
        final exportData = importData['exportData'] as Map<String, dynamic>;
        
        for (final entry in exportData.entries) {
          await _prefs.setString(entry.key, entry.value as String);
        }
        
        return true;
      }
    } catch (e) {
      // Import failed
    }
    return false;
  }
}
