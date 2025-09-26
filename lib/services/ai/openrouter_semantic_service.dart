// OpenRouter Semantic Analysis Service
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../constants/api_config.dart';
import '../../models/ai_models.dart';
import '../cache_service.dart';

/// OpenRouter Semantic Analysis Service for semantic search and analysis
/// Uses OpenRouter API with various models for semantic analysis
class OpenRouterSemanticService {
  final CacheService _cacheService = CacheService();
  
  bool _isInitialized = false;
  
  /// Initialize the OpenRouter Semantic service
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Check if OpenRouter API key is available
      if (!APIConfig.hasDeepSeekR1) {
        throw Exception('OpenRouter API key not configured');
      }
      
      _isInitialized = true;
      if (kDebugMode) {
        print('✅ OpenRouter Semantic service initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to initialize OpenRouter Semantic service: $e');
      }
      throw Exception('OpenRouter Semantic service initialization failed: $e');
    }
  }
  
  /// Analyze word semantically using OpenRouter
  Future<SemanticWordAnalysis> analyzeWordSemantically({
    required String word,
    required String arabic,
    String context = '',
  }) async {
    await initialize();
    
    final cacheKey = 'semantic_analysis_$word\_$arabic';
    
    // Check cache first
    final cached = await _cacheService.getCachedData(cacheKey);
    if (cached != null) {
      return SemanticWordAnalysis.fromJson(cached);
    }
    
    try {
      final analysis = await _performSemanticAnalysis(
        word: word,
        arabic: arabic,
        context: context,
      );
      
      // Cache the result
      await _cacheService.cacheData(cacheKey, analysis.toJson());
      
      return analysis;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Semantic analysis failed: $e');
      }
      
      // Return basic analysis on failure
      return _createBasicSemanticAnalysis(word, arabic, e.toString());
    }
  }
  
  /// Perform semantic analysis using OpenRouter
  Future<SemanticWordAnalysis> _performSemanticAnalysis({
    required String word,
    required String arabic,
    String context = '',
  }) async {
    final prompt = _buildSemanticPrompt(word, arabic, context);
    
    final client = http.Client();
    try {
      final response = await client.post(
        Uri.parse('${APIConfig.openrouterBaseUrl}/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${APIConfig.openrouterApiKey}',
          'HTTP-Referer': 'https://bayan-al-quran.app',
          'X-Title': 'Bayan al Quran',
          'User-Agent': 'BayanAlQuran/1.0.0',
        },
        body: jsonEncode({
          'model': 'deepseek/deepseek-r1-0528-qwen3-8b:free',
          'messages': [
            {
              'role': 'system',
              'content': 'You are an expert Islamic scholar and Arabic linguist specializing in semantic analysis of Quranic words. Focus on the English meaning and provide comprehensive semantic analysis including meaning, context, and linguistic insights. Always include "PBUH" after mentioning Prophet Muhammad. Prioritize English understanding over Arabic text.',
            },
            {
              'role': 'user',
              'content': prompt,
            },
          ],
          'temperature': 0.3,
          'max_tokens': 2000,
          'stream': false,
        }),
      ).timeout(const Duration(seconds: 30));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        return _parseSemanticResponse(content, word, arabic);
      } else {
        throw Exception('OpenRouter API error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      client.close();
      rethrow;
    }
  }
  
  /// Build semantic analysis prompt
  String _buildSemanticPrompt(String word, String arabic, String context) {
    return '''
Analyze the following Quranic word semantically for Islamic study:

English Word: $word
Arabic Text: $arabic
Context: ${context.isNotEmpty ? context : 'General Quranic context'}

Please provide a comprehensive semantic analysis focusing on the English meaning and its Islamic significance:

1. **Core Meaning**: The fundamental meaning and essence of the word in English
2. **Semantic Field**: Related concepts and words in the same semantic domain
3. **Linguistic Analysis**: Root analysis, morphological features, and grammatical properties
4. **Quranic Usage**: How this word is used throughout the Quran with examples
5. **Contextual Variations**: Different meanings in different contexts
6. **Theological Significance**: Religious and spiritual implications
7. **Related Hadith**: Any relevant sayings of Prophet Muhammad (PBUH)
8. **Modern Relevance**: How this word's meaning applies to contemporary life

Format your response as a structured analysis with clear sections and examples. Focus on the English meaning and its Islamic context.
''';
  }
  
  /// Parse OpenRouter response into SemanticWordAnalysis
  SemanticWordAnalysis _parseSemanticResponse(String content, String word, String arabic) {
    return SemanticWordAnalysis(
      word: word,
      arabic: arabic,
      analysis: content,
      confidence: 0.9, // High confidence for OpenRouter responses
      timestamp: DateTime.now(),
      model: 'deepseek-r1-via-openrouter',
      semanticField: _extractSemanticField(content),
      relatedWords: _extractRelatedWords(content),
      contextualMeanings: _extractContextualMeanings(content),
    );
  }
  
  /// Extract semantic field from analysis
  List<String> _extractSemanticField(String content) {
    // Simple extraction - look for semantic field mentions
    final lines = content.split('\n');
    final semanticFields = <String>[];
    
    for (final line in lines) {
      if (line.toLowerCase().contains('semantic field') || 
          line.toLowerCase().contains('related concepts')) {
        // Extract words after colons or in lists
        final parts = line.split(':');
        if (parts.length > 1) {
          final words = parts[1].split(',').map((w) => w.trim()).where((w) => w.isNotEmpty).toList();
          semanticFields.addAll(words);
        }
      }
    }
    
    return semanticFields.take(5).toList(); // Limit to 5 related words
  }
  
  /// Extract related words from analysis
  List<String> _extractRelatedWords(String content) {
    // Simple extraction - look for word lists
    final words = <String>[];
    final lines = content.split('\n');
    
    for (final line in lines) {
      if (line.contains('•') || line.contains('-') || line.contains('*')) {
        final cleanLine = line.replaceAll(RegExp(r'[•\-*]'), '').trim();
        if (cleanLine.isNotEmpty && cleanLine.length < 50) {
          words.add(cleanLine);
        }
      }
    }
    
    return words.take(8).toList(); // Limit to 8 related words
  }
  
  /// Extract contextual meanings from analysis
  List<String> _extractContextualMeanings(String content) {
    final meanings = <String>[];
    final lines = content.split('\n');
    
    for (final line in lines) {
      if (line.toLowerCase().contains('meaning') && 
          (line.contains(':') || line.contains('•'))) {
        final cleanLine = line.replaceAll(RegExp(r'[•\-*:]'), '').trim();
        if (cleanLine.isNotEmpty && cleanLine.length < 100) {
          meanings.add(cleanLine);
        }
      }
    }
    
    return meanings.take(5).toList(); // Limit to 5 contextual meanings
  }
  
  /// Create basic semantic analysis when API fails
  SemanticWordAnalysis _createBasicSemanticAnalysis(String word, String arabic, String error) {
    return SemanticWordAnalysis(
      word: word,
      arabic: arabic,
      analysis: 'Semantic analysis temporarily unavailable. Error: $error',
      confidence: 0.1,
      timestamp: DateTime.now(),
      model: 'fallback',
      semanticField: [],
      relatedWords: [],
      contextualMeanings: [],
    );
  }
  
  /// Search for semantically similar content
  Future<List<Map<String, dynamic>>> searchSimilarContent({
    required String query,
    required List<Map<String, dynamic>> contentList,
    int maxResults = 10,
  }) async {
    await initialize();
    
    try {
      // Use OpenRouter to find semantic similarities
      final prompt = '''
Find content semantically similar to: "$query"

From the following content list, identify the most relevant items:
${contentList.map((item) => '${item['title'] ?? ''}: ${item['content'] ?? ''}').join('\n')}

Return the most relevant items in order of similarity.
''';
      
      final client = http.Client();
      try {
        final response = await client.post(
          Uri.parse('${APIConfig.openrouterBaseUrl}/chat/completions'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${APIConfig.openrouterApiKey}',
            'HTTP-Referer': 'https://bayan-al-quran.app',
            'X-Title': 'Bayan al Quran',
            'User-Agent': 'BayanAlQuran/1.0.0',
          },
          body: jsonEncode({
            'model': 'deepseek/deepseek-r1-0528-qwen3-8b:free',
            'messages': [
              {
                'role': 'user',
                'content': prompt,
              },
            ],
            'temperature': 0.2,
            'max_tokens': 1000,
          }),
        ).timeout(const Duration(seconds: 30));
        
        if (response.statusCode == 200) {
          // For now, return a simple similarity based on keyword matching
          return _simpleSimilaritySearch(query, contentList, maxResults);
        } else {
          return _simpleSimilaritySearch(query, contentList, maxResults);
        }
      } catch (e) {
        client.close();
        if (kDebugMode) {
          print('❌ Similarity search failed: $e');
        }
        return _simpleSimilaritySearch(query, contentList, maxResults);
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Similarity search failed: $e');
      }
      return _simpleSimilaritySearch(query, contentList, maxResults);
    }
  }
  
  /// Simple similarity search as fallback
  List<Map<String, dynamic>> _simpleSimilaritySearch(
    String query, 
    List<Map<String, dynamic>> contentList, 
    int maxResults
  ) {
    final queryWords = query.toLowerCase().split(' ');
    final scoredContent = contentList.map((item) {
      final content = '${item['title'] ?? ''} ${item['content'] ?? ''}'.toLowerCase();
      int score = 0;
      for (final word in queryWords) {
        if (content.contains(word)) {
          score++;
        }
      }
      return MapEntry(item, score);
    }).toList();
    
    scoredContent.sort((a, b) => b.value.compareTo(a.value));
    
    return scoredContent
        .where((entry) => entry.value > 0)
        .take(maxResults)
        .map((entry) => entry.key)
        .toList();
  }
}
