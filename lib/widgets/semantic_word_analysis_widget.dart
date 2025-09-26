// Semantic Word Analysis Widget for Quran Module
import 'package:flutter/material.dart';
import '../services/ai/openrouter_semantic_service.dart';
import '../models/ai_models.dart';
import 'arabic_text.dart';

/// Widget for displaying semantic word analysis using OpenRouter
class SemanticWordAnalysisWidget extends StatefulWidget {
  final String word;
  final String arabic;
  final String? context;
  final VoidCallback? onClose;
  
  const SemanticWordAnalysisWidget({
    super.key,
    required this.word,
    required this.arabic,
    this.context,
    this.onClose,
  });

  @override
  State<SemanticWordAnalysisWidget> createState() => _SemanticWordAnalysisWidgetState();
}

class _SemanticWordAnalysisWidgetState extends State<SemanticWordAnalysisWidget> {
  final OpenRouterSemanticService _semanticService = OpenRouterSemanticService();
  
  SemanticWordAnalysis? _analysis;
  bool _isLoading = true;
  String? _error;
  
  @override
  void initState() {
    super.initState();
    _analyzeWord();
  }
  
  Future<void> _analyzeWord() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      
      final analysis = await _semanticService.analyzeWordSemantically(
        word: widget.word,
        arabic: widget.arabic,
        context: widget.context ?? '',
      );
      
      setState(() {
        _analysis = analysis;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.psychology,
                color: colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Semantic Analysis',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Understanding by meaning',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: widget.onClose,
                tooltip: 'Close analysis',
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Word display
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // Arabic word
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: ArabicText(
                    widget.arabic,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                const SizedBox(width: 16),
                // English word
                Text(
                  widget.word,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Content
          if (_isLoading)
            _buildLoadingState(theme, colorScheme)
          else if (_error != null)
            _buildErrorState(theme, colorScheme)
          else if (_analysis != null)
            _buildAnalysisContent(theme, colorScheme)
          else
            _buildEmptyState(theme, colorScheme),
        ],
      ),
    );
  }
  
  Widget _buildLoadingState(ThemeData theme, ColorScheme colorScheme) {
    return Center(
      child: Column(
        children: [
          CircularProgressIndicator(
            color: colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Analyzing word semantics...',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildErrorState(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            color: colorScheme.error,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            'Analysis Failed',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.error,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _error ?? 'Unknown error occurred',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onErrorContainer,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _analyzeWord,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEmptyState(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.psychology_outlined,
            color: colorScheme.onSurfaceVariant,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            'No Analysis Available',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Semantic analysis could not be generated for this word.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildAnalysisContent(ThemeData theme, ColorScheme colorScheme) {
    final analysis = _analysis!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Semantic Field
        _buildSection(
          title: 'Semantic Field',
          content: analysis.semanticField.join(', '),
          icon: Icons.category,
          theme: theme,
          colorScheme: colorScheme,
        ),
        
        const SizedBox(height: 16),
        
        // Related Words
        if (analysis.relatedWords.isNotEmpty)
          _buildSection(
            title: 'Related Words',
            content: analysis.relatedWords.join(', '),
            icon: Icons.link,
            theme: theme,
            colorScheme: colorScheme,
          ),
        
        const SizedBox(height: 16),
        
        // Contextual Meanings
        if (analysis.contextualMeanings.isNotEmpty)
          _buildContextualMeanings(analysis.contextualMeanings, theme, colorScheme),
        
        const SizedBox(height: 16),
        
        // Confidence Score
        _buildConfidenceScore(analysis.confidence, theme, colorScheme),
      ],
    );
  }
  
  Widget _buildSection({
    required String title,
    required String content,
    required IconData icon,
    required ThemeData theme,
    required ColorScheme colorScheme,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildContextualMeanings(
    List<String> meanings,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.psychology_outlined,
                size: 20,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Text(
                'Contextual Meanings',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...meanings.map((meaning) => _buildMeaningItem(meaning, theme, colorScheme)),
        ],
      ),
    );
  }
  
  Widget _buildMeaningItem(
    String meaning,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          // Bullet point
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          // Meaning text
          Expanded(
            child: Text(
              meaning,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildConfidenceScore(double confidence, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _getConfidenceColor(confidence, colorScheme).withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.analytics,
            size: 20,
            color: _getConfidenceColor(confidence, colorScheme),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Analysis Confidence',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${(confidence * 100).toInt()}% - ${_getConfidenceDescription(confidence)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  
  Color _getConfidenceColor(double confidence, ColorScheme colorScheme) {
    if (confidence >= 0.8) return colorScheme.primary;
    if (confidence >= 0.6) return colorScheme.secondary;
    return colorScheme.tertiary;
  }
  
  String _getConfidenceDescription(double confidence) {
    if (confidence >= 0.9) return 'Very High';
    if (confidence >= 0.8) return 'High';
    if (confidence >= 0.6) return 'Medium';
    if (confidence >= 0.4) return 'Low';
    return 'Very Low';
  }
}
