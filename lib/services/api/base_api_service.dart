import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Base API service class that provides common functionality for all API services
class BaseApiService {
  static const String _baseUrl = 'https://api.alquran.cloud/v1';
  static const String _hadithBaseUrl = 'https://api.hadith.gading.dev';
  static const String _prayerBaseUrl = 'https://api.aladhan.com/v1';
  
  late final Dio _dio;
  late final SharedPreferences _prefs;
  
  BaseApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    
    _initializePrefs();
  }
  
  Future<void> _initializePrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  /// Check if device is connected to internet
  Future<bool> isConnected() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      return false;
    }
  }
  
  /// Get cached data with expiration check
  Future<T?> getCachedData<T>(String key, Duration expiration) async {
    try {
      final cachedData = _prefs.getString(key);
      final cachedTime = _prefs.getInt('${key}_timestamp');
      
      if (cachedData != null && cachedTime != null) {
        final cacheTime = DateTime.fromMillisecondsSinceEpoch(cachedTime);
        final now = DateTime.now();
        
        if (now.difference(cacheTime) < expiration) {
          return json.decode(cachedData) as T;
        }
      }
    } catch (e) {
      // Cache read failed, continue with API call
    }
    return null;
  }
  
  /// Cache data with timestamp
  Future<void> cacheData(String key, dynamic data) async {
    try {
      await _prefs.setString(key, json.encode(data));
      await _prefs.setInt('${key}_timestamp', DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      // Cache write failed, continue without caching
    }
  }
  
  /// Make HTTP GET request with caching and offline support
  Future<T> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Duration cacheExpiration = const Duration(hours: 1),
    String? cacheKey,
    T Function(dynamic)? fromJson,
  }) async {
    final fullCacheKey = cacheKey ?? endpoint;
    
    // Try to get cached data first
    final cachedData = await getCachedData<T>(fullCacheKey, cacheExpiration);
    if (cachedData != null) {
      return cachedData;
    }
    
    // Check connectivity
    final connected = await isConnected();
    if (!connected) {
      throw Exception('No internet connection. Please check your network and try again.');
    }
    
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        // Cache the response
        await cacheData(fullCacheKey, data);
        
        if (fromJson != null) {
          return fromJson(data);
        }
        return data as T;
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Request timeout. Please check your connection and try again.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('Connection error. Please check your internet connection.');
      } else {
        throw Exception('API request failed: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
  
  /// Make HTTP POST request
  Future<T> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    final connected = await isConnected();
    if (!connected) {
      throw Exception('No internet connection. Please check your network and try again.');
    }
    
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        
        if (fromJson != null) {
          return fromJson(responseData);
        }
        return responseData as T;
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Request timeout. Please check your connection and try again.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('Connection error. Please check your internet connection.');
      } else {
        throw Exception('API request failed: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
  
  /// Clear all cached data
  Future<void> clearCache() async {
    try {
      final keys = _prefs.getKeys();
      for (final key in keys) {
        if (key.endsWith('_timestamp')) {
          await _prefs.remove(key);
        }
      }
    } catch (e) {
      // Cache clear failed, continue
    }
  }
  
  /// Clear specific cached data
  Future<void> clearCachedData(String key) async {
    try {
      await _prefs.remove(key);
      await _prefs.remove('${key}_timestamp');
    } catch (e) {
      // Cache clear failed, continue
    }
  }
  
  /// Get base URL for different services
  String get baseUrl => _baseUrl;
  String get hadithBaseUrl => _hadithBaseUrl;
  String get prayerBaseUrl => _prayerBaseUrl;
}
