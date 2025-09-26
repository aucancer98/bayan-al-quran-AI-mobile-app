// API Configuration for DeepSeek R1 via OpenRouter
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class APIConfig {
  
  // API Keys - Only OpenRouter for DeepSeek R1
  static String? _openrouterApiKey;
  
  // API Endpoints
  static const String openrouterBaseUrl = 'https://openrouter.ai/api/v1';
  
  // Initialize API keys from environment variables
  static Future<void> initialize() async {
    print('🔄 Initializing API configuration...');
    
    // Try to load from environment variables first
    _openrouterApiKey = Platform.environment['OPENROUTER_API_KEY'];
    
    // If OpenRouter API key is found in environment, save it to SharedPreferences
    if (_openrouterApiKey != null && _openrouterApiKey!.isNotEmpty) {
      await _saveToSecureStorage('openrouter_api_key', _openrouterApiKey!);
      print('✅ OpenRouter API key loaded from environment and saved to storage');
    }
    
    // If not found in environment, try to load from secure storage
    if (_openrouterApiKey == null) {
      _openrouterApiKey = await _loadFromSecureStorage('openrouter_api_key');
    }
    
    // Print final status
    print('📊 API Configuration Status:');
    print('   DeepSeek R1 (OpenRouter): ${hasDeepSeekR1 ? "✅ Available" : "❌ Not configured"}');
    if (hasDeepSeekR1) {
      print('   Key length: ${_openrouterApiKey!.length} characters');
    }
    print('   Primary Service: ${primaryService}');
    print('   Available Services: ${availableServices.join(", ")}');
  }
  
  // Set API key programmatically (for testing or manual configuration)
  static void setOpenRouterKey(String key) {
    _openrouterApiKey = key;
  }
  
  // Get API key
  static String? get openrouterApiKey => _openrouterApiKey;
  
  // Check if API key is available
  static bool get hasDeepSeekR1 => _openrouterApiKey != null && _openrouterApiKey!.isNotEmpty;
  
  // Get available AI services
  static List<String> get availableServices {
    List<String> services = [];
    if (hasDeepSeekR1) services.add('DeepSeekR1');
    return services;
  }
  
  // Check if any AI service is available
  static bool get hasAnyAIService => availableServices.isNotEmpty;
  
  // Get primary AI service (only DeepSeek R1)
  static String get primaryService {
    if (hasDeepSeekR1) return 'DeepSeekR1';
    return 'None';
  }
  
  // Load from SharedPreferences
  static Future<String?> _loadFromSecureStorage(String key) async {
    return await _loadFromSharedPreferences(key);
  }
  
  // Fallback method to load from SharedPreferences
  static Future<String?> _loadFromSharedPreferences(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final value = prefs.getString(key);
      if (value != null) {
        print('✅ Loaded $key from SharedPreferences (${value.length} chars)');
      } else {
        print('❌ No value found for $key in SharedPreferences');
      }
      return value;
    } catch (e) {
      print('❌ Error loading from SharedPreferences: $e');
      return null;
    }
  }
  
  // Save to SharedPreferences
  static Future<void> _saveToSecureStorage(String key, String value) async {
    await _saveToSharedPreferences(key, value);
  }
  
  // Fallback method to save to SharedPreferences
  static Future<void> _saveToSharedPreferences(String key, String value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
      print('✅ Saved $key to SharedPreferences (${value.length} chars)');
    } catch (e) {
      print('❌ Error saving to SharedPreferences: $e');
    }
  }
  
  // Save OpenRouter API key with validation
  static Future<bool> saveOpenRouterKey(String key) async {
    if (isValidOpenRouterKey(key)) {
      await _saveToSecureStorage('openrouter_api_key', key);
      _openrouterApiKey = key;
      return true;
    }
    return false;
  }
  
  // Remove OpenRouter API key
  static Future<void> removeOpenRouterKey() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('openrouter_api_key');
      print('✅ Removed openrouter_api_key from SharedPreferences');
    } catch (e) {
      print('❌ Error removing from SharedPreferences: $e');
    }
    _openrouterApiKey = null;
  }
  
  // Validate OpenRouter API key
  static bool isValidOpenRouterKey(String key) {
    return key.startsWith('sk-or-') && key.length >= 50;
  }
  
  // Get API status for debugging
  static Map<String, dynamic> get status {
    return {
      'deepseek_r1': hasDeepSeekR1,
      'primary_service': primaryService,
      'available_services': availableServices,
      'has_any_ai_service': hasAnyAIService,
    };
  }
}