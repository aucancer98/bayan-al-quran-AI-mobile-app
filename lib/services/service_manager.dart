import 'package:connectivity_plus/connectivity_plus.dart';
import 'cache_service.dart';
import 'api/quran_api_service.dart';
import 'api/hadith_api_service.dart';
import 'api/prayer_times_api_service.dart';
import 'ai/openrouter_semantic_service.dart';

/// Service manager to handle app initialization, connectivity, and offline support
class ServiceManager {
  static final ServiceManager _instance = ServiceManager._internal();
  factory ServiceManager() => _instance;
  ServiceManager._internal();
  
  late CacheService _cacheService;
  late QuranApiService _quranApiService;
  late HadithApiService _hadithApiService;
  late PrayerTimesApiService _prayerApiService;
  late OpenRouterSemanticService _semanticService;
  
  bool _isInitialized = false;
  bool _isOnline = true;
  
  /// Initialize all services
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Initialize cache service
      _cacheService = CacheService();
      await _cacheService.initialize();
      
      // Initialize API services
      _quranApiService = QuranApiService();
      _hadithApiService = HadithApiService();
      _prayerApiService = PrayerTimesApiService();
      
      // Initialize AI services
      _semanticService = OpenRouterSemanticService();
      await _semanticService.initialize();
      
      // Check connectivity
      await _checkConnectivity();
      
      // Preload essential data for offline use
      await _preloadEssentialData();
      
      _isInitialized = true;
    } catch (e) {
      // Initialization failed, but continue with limited functionality
      _isInitialized = true;
    }
  }
  
  /// Check current connectivity status
  Future<void> _checkConnectivity() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      _isOnline = connectivityResult != ConnectivityResult.none;
    } catch (e) {
      _isOnline = false;
    }
  }
  
  /// Preload essential data for offline use
  Future<void> _preloadEssentialData() async {
    try {
      if (_isOnline) {
        await _cacheService.preloadEssentialData();
      }
    } catch (e) {
      // Preload failed, continue without offline data
    }
  }
  
  /// Get current connectivity status
  bool get isOnline => _isOnline;
  
  /// Get cache service
  CacheService get cacheService => _cacheService;
  
  /// Get Quran API service
  QuranApiService get quranApiService => _quranApiService;
  
  /// Get Hadith API service
  HadithApiService get hadithApiService => _hadithApiService;
  
  /// Get Prayer Times API service
  PrayerTimesApiService get prayerApiService => _prayerApiService;
  
  /// Get OpenRouter Semantic service
  OpenRouterSemanticService get semanticService => _semanticService;
  
  /// Check if services are initialized
  bool get isInitialized => _isInitialized;
  
  /// Refresh connectivity status
  Future<void> refreshConnectivity() async {
    await _checkConnectivity();
  }
  
  /// Force refresh all cached data
  Future<void> refreshAllData() async {
    if (!_isOnline) return;
    
    try {
      // Clear existing cache
      await _cacheService.clearAllCache();
      
      // Preload fresh data
      await _preloadEssentialData();
    } catch (e) {
      // Refresh failed
    }
  }
  
  /// Get cache information
  Future<Map<String, dynamic>> getCacheInfo() async {
    return await _cacheService.getCacheInfo();
  }
  
  /// Clear all cache
  Future<void> clearCache() async {
    await _cacheService.clearAllCache();
  }
  
  /// Export cache data for backup
  Future<Map<String, dynamic>> exportCacheData() async {
    return await _cacheService.exportCacheData();
  }
  
  /// Import cache data from backup
  Future<bool> importCacheData(Map<String, dynamic> data) async {
    return await _cacheService.importCacheData(data);
  }
  
  /// Handle app going to background
  Future<void> onAppPaused() async {
    // Save any pending data
    try {
      // Could save user progress, bookmarks, etc.
    } catch (e) {
      // Handle error
    }
  }
  
  /// Handle app resuming from background
  Future<void> onAppResumed() async {
    // Refresh connectivity and data if needed
    await refreshConnectivity();
    
    if (_isOnline) {
      // Could refresh data that might have changed
      // For now, just ensure cache is up to date
    }
  }
  
  /// Handle app termination
  Future<void> onAppTerminated() async {
    // Clean up resources
    try {
      // Save any pending data
    } catch (e) {
      // Handle error
    }
  }
}
