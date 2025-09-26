// Simple script to set API key without Flutter dependencies
import 'dart:io';

void main() async {
  print('🔑 Setting OpenRouter API Key');
  print('=' * 40);
  
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
  
  // Create a simple file with the API key
  final keyFile = File('openrouter_api_key.txt');
  await keyFile.writeAsString(apiKey);
  
  print('✅ API key saved to openrouter_api_key.txt');
  print('');
  print('To use this in your Flutter app:');
  print('1. Copy the API key from openrouter_api_key.txt');
  print('2. Set it in your app settings or environment');
  print('3. The app should now be able to use DeepSeek R1 for AI analysis');
  
  print('');
  print('API Key: $apiKey');
}

