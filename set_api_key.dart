// Script to set OpenRouter API key in SharedPreferences
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  print('🔑 Setting OpenRouter API Key in SharedPreferences');
  print('=' * 50);
  
  // Check if OpenRouter API key is set in environment
  final apiKey = Platform.environment['OPENROUTER_API_KEY'];
  if (apiKey == null || apiKey.isEmpty) {
    print('❌ OpenRouter API key is not set in environment!');
    print('Please set it first:');
    print('export OPENROUTER_API_KEY="sk-or-your-actual-api-key-here"');
    exit(1);
  }
  
  print('✅ OpenRouter API key found in environment');
  print('Key length: ${apiKey.length} characters');
  print('');
  
  try {
    // Initialize SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    
    // Save the API key
    await prefs.setString('openrouter_api_key', apiKey);
    
    print('✅ API key saved to SharedPreferences successfully!');
    print('');
    print('The app should now be able to use DeepSeek R1 for AI analysis.');
    print('You can now run the Flutter app and test the word analysis feature.');
    
  } catch (e) {
    print('❌ Failed to save API key: $e');
  }
}

