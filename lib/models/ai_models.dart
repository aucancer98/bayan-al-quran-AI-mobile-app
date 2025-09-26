// AI-powered analysis models for Quranic and Sunnah insights

class QuranicAnalysis {
  final String word;
  final String arabic;
  final String root;
  final List<WordOccurrence> occurrences;
  final List<HadithReference> relatedHadiths;
  final List<ThematicAnalysis> themes;
  final List<LinguisticAnalysis> linguisticInsights;
  final List<ContextualAnalysis> contexts;
  final List<ScholarlyInsight> scholarlyInsights;
  final double confidence;
  final DateTime generatedAt;

  const QuranicAnalysis({
    required this.word,
    required this.arabic,
    required this.root,
    required this.occurrences,
    required this.relatedHadiths,
    required this.themes,
    required this.linguisticInsights,
    required this.contexts,
    required this.scholarlyInsights,
    required this.confidence,
    required this.generatedAt,
  });

  factory QuranicAnalysis.fromJson(Map<String, dynamic> json) {
    return QuranicAnalysis(
      word: json['word'] as String,
      arabic: json['arabic'] as String,
      root: json['root'] as String,
      occurrences: (json['occurrences'] as List<dynamic>)
          .map((occ) => WordOccurrence.fromJson(occ as Map<String, dynamic>))
          .toList(),
      relatedHadiths: (json['relatedHadiths'] as List<dynamic>)
          .map((hadith) => HadithReference.fromJson(hadith as Map<String, dynamic>))
          .toList(),
      themes: (json['themes'] as List<dynamic>)
          .map((theme) => ThematicAnalysis.fromJson(theme as Map<String, dynamic>))
          .toList(),
      linguisticInsights: (json['linguisticInsights'] as List<dynamic>)
          .map((insight) => LinguisticAnalysis.fromJson(insight as Map<String, dynamic>))
          .toList(),
      contexts: (json['contexts'] as List<dynamic>)
          .map((context) => ContextualAnalysis.fromJson(context as Map<String, dynamic>))
          .toList(),
      scholarlyInsights: (json['scholarlyInsights'] as List<dynamic>)
          .map((insight) => ScholarlyInsight.fromJson(insight as Map<String, dynamic>))
          .toList(),
      confidence: (json['confidence'] as num).toDouble(),
      generatedAt: DateTime.parse(json['generatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'arabic': arabic,
      'root': root,
      'occurrences': occurrences.map((occ) => occ.toJson()).toList(),
      'relatedHadiths': relatedHadiths.map((hadith) => hadith.toJson()).toList(),
      'themes': themes.map((theme) => theme.toJson()).toList(),
      'linguisticInsights': linguisticInsights.map((insight) => insight.toJson()).toList(),
      'contexts': contexts.map((context) => context.toJson()).toList(),
      'scholarlyInsights': scholarlyInsights.map((insight) => insight.toJson()).toList(),
      'confidence': confidence,
      'generatedAt': generatedAt.toIso8601String(),
    };
  }
}

class WordOccurrence {
  final int surahNumber;
  final int ayahNumber;
  final String surahName;
  final String ayahText;
  final String context;
  final String translation;
  final List<String> relatedWords;
  final String grammaticalRole;
  final String semanticField;

  const WordOccurrence({
    required this.surahNumber,
    required this.ayahNumber,
    required this.surahName,
    required this.ayahText,
    required this.context,
    required this.translation,
    required this.relatedWords,
    required this.grammaticalRole,
    required this.semanticField,
  });

  factory WordOccurrence.fromJson(Map<String, dynamic> json) {
    return WordOccurrence(
      surahNumber: json['surahNumber'] as int,
      ayahNumber: json['ayahNumber'] as int,
      surahName: json['surahName'] as String,
      ayahText: json['ayahText'] as String,
      context: json['context'] as String,
      translation: json['translation'] as String,
      relatedWords: (json['relatedWords'] as List<dynamic>)
          .map((word) => word as String)
          .toList(),
      grammaticalRole: json['grammaticalRole'] as String,
      semanticField: json['semanticField'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'surahNumber': surahNumber,
      'ayahNumber': ayahNumber,
      'surahName': surahName,
      'ayahText': ayahText,
      'context': context,
      'translation': translation,
      'relatedWords': relatedWords,
      'grammaticalRole': grammaticalRole,
      'semanticField': semanticField,
    };
  }
}

class HadithReference {
  final String id;
  final String collection;
  final String textArabic;
  final String textEnglish;
  final String narrator;
  final String grade;
  final String relevance;
  final String explanation;
  final List<String> keywords;

  const HadithReference({
    required this.id,
    required this.collection,
    required this.textArabic,
    required this.textEnglish,
    required this.narrator,
    required this.grade,
    required this.relevance,
    required this.explanation,
    required this.keywords,
  });

  factory HadithReference.fromJson(Map<String, dynamic> json) {
    return HadithReference(
      id: json['id'] as String,
      collection: json['collection'] as String,
      textArabic: json['textArabic'] as String,
      textEnglish: json['textEnglish'] as String,
      narrator: json['narrator'] as String,
      grade: json['grade'] as String,
      relevance: json['relevance'] as String,
      explanation: json['explanation'] as String,
      keywords: (json['keywords'] as List<dynamic>)
          .map((keyword) => keyword as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'collection': collection,
      'textArabic': textArabic,
      'textEnglish': textEnglish,
      'narrator': narrator,
      'grade': grade,
      'relevance': relevance,
      'explanation': explanation,
      'keywords': keywords,
    };
  }
}

class ThematicAnalysis {
  final String theme;
  final String description;
  final List<String> relatedAyahs;
  final List<String> relatedHadiths;
  final String significance;
  final double relevanceScore;

  const ThematicAnalysis({
    required this.theme,
    required this.description,
    required this.relatedAyahs,
    required this.relatedHadiths,
    required this.significance,
    required this.relevanceScore,
  });

  factory ThematicAnalysis.fromJson(Map<String, dynamic> json) {
    return ThematicAnalysis(
      theme: json['theme'] as String,
      description: json['description'] as String,
      relatedAyahs: (json['relatedAyahs'] as List<dynamic>)
          .map((ayah) => ayah as String)
          .toList(),
      relatedHadiths: (json['relatedHadiths'] as List<dynamic>)
          .map((hadith) => hadith as String)
          .toList(),
      significance: json['significance'] as String,
      relevanceScore: (json['relevanceScore'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'theme': theme,
      'description': description,
      'relatedAyahs': relatedAyahs,
      'relatedHadiths': relatedHadiths,
      'significance': significance,
      'relevanceScore': relevanceScore,
    };
  }
}

class LinguisticAnalysis {
  final String aspect;
  final String description;
  final List<String> examples;
  final String grammaticalRule;
  final String morphologicalPattern;
  final String semanticField;

  const LinguisticAnalysis({
    required this.aspect,
    required this.description,
    required this.examples,
    required this.grammaticalRule,
    required this.morphologicalPattern,
    required this.semanticField,
  });

  factory LinguisticAnalysis.fromJson(Map<String, dynamic> json) {
    return LinguisticAnalysis(
      aspect: json['aspect'] as String,
      description: json['description'] as String,
      examples: (json['examples'] as List<dynamic>)
          .map((example) => example as String)
          .toList(),
      grammaticalRule: json['grammaticalRule'] as String,
      morphologicalPattern: json['morphologicalPattern'] as String,
      semanticField: json['semanticField'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'aspect': aspect,
      'description': description,
      'examples': examples,
      'grammaticalRule': grammaticalRule,
      'morphologicalPattern': morphologicalPattern,
      'semanticField': semanticField,
    };
  }
}

class ContextualAnalysis {
  final String context;
  final String explanation;
  final List<String> relatedVerses;
  final String historicalBackground;
  final String contemporaryRelevance;

  const ContextualAnalysis({
    required this.context,
    required this.explanation,
    required this.relatedVerses,
    required this.historicalBackground,
    required this.contemporaryRelevance,
  });

  factory ContextualAnalysis.fromJson(Map<String, dynamic> json) {
    return ContextualAnalysis(
      context: json['context'] as String,
      explanation: json['explanation'] as String,
      relatedVerses: (json['relatedVerses'] as List<dynamic>)
          .map((verse) => verse as String)
          .toList(),
      historicalBackground: json['historicalBackground'] as String,
      contemporaryRelevance: json['contemporaryRelevance'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'context': context,
      'explanation': explanation,
      'relatedVerses': relatedVerses,
      'historicalBackground': historicalBackground,
      'contemporaryRelevance': contemporaryRelevance,
    };
  }
}

class ScholarlyInsight {
  final String scholar;
  final String school;
  final String insight;
  final String reference;
  final String credibility;
  final List<String> supportingEvidence;

  const ScholarlyInsight({
    required this.scholar,
    required this.school,
    required this.insight,
    required this.reference,
    required this.credibility,
    required this.supportingEvidence,
  });

  factory ScholarlyInsight.fromJson(Map<String, dynamic> json) {
    return ScholarlyInsight(
      scholar: json['scholar'] as String,
      school: json['school'] as String,
      insight: json['insight'] as String,
      reference: json['reference'] as String,
      credibility: json['credibility'] as String,
      supportingEvidence: (json['supportingEvidence'] as List<dynamic>)
          .map((evidence) => evidence as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scholar': scholar,
      'school': school,
      'insight': insight,
      'reference': reference,
      'credibility': credibility,
      'supportingEvidence': supportingEvidence,
    };
  }
}

class AIQuery {
  final String query;
  final String type; // 'word', 'ayah', 'theme', 'concept'
  final String language;
  final Map<String, dynamic> context;
  final List<String> filters;

  const AIQuery({
    required this.query,
    required this.type,
    required this.language,
    required this.context,
    required this.filters,
  });

  factory AIQuery.fromJson(Map<String, dynamic> json) {
    return AIQuery(
      query: json['query'] as String,
      type: json['type'] as String,
      language: json['language'] as String,
      context: Map<String, dynamic>.from(json['context'] as Map),
      filters: (json['filters'] as List<dynamic>)
          .map((filter) => filter as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'query': query,
      'type': type,
      'language': language,
      'context': context,
      'filters': filters,
    };
  }
}

class AIResponse {
  final String id;
  final QuranicAnalysis? analysis;
  final String summary;
  final List<String> suggestions;
  final double confidence;
  final DateTime generatedAt;
  final String model;
  final Map<String, dynamic> metadata;

  const AIResponse({
    required this.id,
    this.analysis,
    required this.summary,
    required this.suggestions,
    required this.confidence,
    required this.generatedAt,
    required this.model,
    required this.metadata,
  });

  factory AIResponse.fromJson(Map<String, dynamic> json) {
    return AIResponse(
      id: json['id'] as String,
      analysis: json['analysis'] != null
          ? QuranicAnalysis.fromJson(json['analysis'] as Map<String, dynamic>)
          : null,
      summary: json['summary'] as String,
      suggestions: (json['suggestions'] as List<dynamic>)
          .map((suggestion) => suggestion as String)
          .toList(),
      confidence: (json['confidence'] as num).toDouble(),
      generatedAt: DateTime.parse(json['generatedAt'] as String),
      model: json['model'] as String,
      metadata: Map<String, dynamic>.from(json['metadata'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'analysis': analysis?.toJson(),
      'summary': summary,
      'suggestions': suggestions,
      'confidence': confidence,
      'generatedAt': generatedAt.toIso8601String(),
      'model': model,
      'metadata': metadata,
    };
  }
}

class SemanticWordAnalysis {
  final String word;
  final String arabic;
  final String analysis;
  final double confidence;
  final DateTime timestamp;
  final String model;
  final List<String> semanticField;
  final List<String> relatedWords;
  final List<String> contextualMeanings;

  const SemanticWordAnalysis({
    required this.word,
    required this.arabic,
    required this.analysis,
    required this.confidence,
    required this.timestamp,
    required this.model,
    required this.semanticField,
    required this.relatedWords,
    required this.contextualMeanings,
  });

  factory SemanticWordAnalysis.fromJson(Map<String, dynamic> json) {
    return SemanticWordAnalysis(
      word: json['word'] as String,
      arabic: json['arabic'] as String,
      analysis: json['analysis'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      model: json['model'] as String,
      semanticField: (json['semanticField'] as List<dynamic>)
          .map((field) => field as String)
          .toList(),
      relatedWords: (json['relatedWords'] as List<dynamic>)
          .map((word) => word as String)
          .toList(),
      contextualMeanings: (json['contextualMeanings'] as List<dynamic>)
          .map((meaning) => meaning as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'arabic': arabic,
      'analysis': analysis,
      'confidence': confidence,
      'timestamp': timestamp.toIso8601String(),
      'model': model,
      'semanticField': semanticField,
      'relatedWords': relatedWords,
      'contextualMeanings': contextualMeanings,
    };
  }
}
