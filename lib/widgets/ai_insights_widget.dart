// AI-powered insights widget for displaying comprehensive Quranic analysis
import 'package:flutter/material.dart';
import '../models/ai_models.dart';
import '../services/ai/openrouter_semantic_service.dart';

class AIInsightsWidget extends StatefulWidget {
  final String word;
  final String arabic;
  final String? context;
  final bool showHadith;
  final bool showThemes;
  final bool showLinguistics;

  const AIInsightsWidget({
    super.key,
    required this.word,
    required this.arabic,
    this.context,
    this.showHadith = true,
    this.showThemes = true,
    this.showLinguistics = true,
  });

  @override
  State<AIInsightsWidget> createState() => _AIInsightsWidgetState();
}

class _AIInsightsWidgetState extends State<AIInsightsWidget>
    with SingleTickerProviderStateMixin {
  final OpenRouterSemanticService _aiService = OpenRouterSemanticService();
  late TabController _tabController;
  
  QuranicAnalysis? _analysis;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _loadAnalysis();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAnalysis() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final semanticAnalysis = await _aiService.analyzeWordSemantically(
        word: widget.word,
        arabic: widget.arabic,
        context: widget.context ?? '',
      );
      
      // Convert SemanticWordAnalysis to QuranicAnalysis for compatibility
      final analysis = QuranicAnalysis(
        word: semanticAnalysis.word,
        arabic: semanticAnalysis.arabic,
        root: '', // Not available in semantic analysis
        occurrences: [], // Not available in semantic analysis
        relatedHadiths: [], // Not available in semantic analysis
        themes: [], // Not available in semantic analysis
        linguisticInsights: [], // Not available in semantic analysis
        contexts: [], // Not available in semantic analysis
        scholarlyInsights: [], // Not available in semantic analysis
        confidence: semanticAnalysis.confidence,
        generatedAt: semanticAnalysis.timestamp,
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

    if (_isLoading) {
      return _buildLoadingWidget(theme, colorScheme);
    }

    if (_error != null) {
      return _buildErrorWidget(theme, colorScheme);
    }

    if (_analysis == null) {
      return _buildEmptyWidget(theme, colorScheme);
    }

    return _buildAnalysisWidget(theme, colorScheme);
  }

  Widget _buildLoadingWidget(ThemeData theme, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Analyzing "${widget.arabic}" with AI...',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'This may take a few moments',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(ThemeData theme, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Analysis Failed',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.error,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error ?? 'Unknown error occurred',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadAnalysis,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget(ThemeData theme, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off,
              size: 48,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No Analysis Available',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Unable to analyze this word at the moment',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisWidget(ThemeData theme, ColorScheme colorScheme) {
    return Card(
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.psychology,
                    color: colorScheme.onPrimary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Analysis',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${widget.arabic} (${widget.word})',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${(_analysis!.confidence * 100).toInt()}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Tab Bar
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: const [
              Tab(text: 'Overview', icon: Icon(Icons.info_outline)),
              Tab(text: 'Linguistics', icon: Icon(Icons.language)),
              Tab(text: 'Themes', icon: Icon(Icons.auto_awesome)),
              Tab(text: 'Hadith', icon: Icon(Icons.article)),
              Tab(text: 'Context', icon: Icon(Icons.history_edu)),
            ],
          ),
          
          // Tab Content
          SizedBox(
            height: 400,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(theme, colorScheme),
                _buildLinguisticsTab(theme, colorScheme),
                _buildThemesTab(theme, colorScheme),
                _buildHadithTab(theme, colorScheme),
                _buildContextTab(theme, colorScheme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(ThemeData theme, ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            theme,
            colorScheme,
            'Root Analysis',
            _analysis!.root,
            Icons.architecture,
          ),
          const SizedBox(height: 16),
          _buildSection(
            theme,
            colorScheme,
            'Occurrences in Quran',
            '${_analysis!.occurrences.length} occurrences found',
            Icons.search,
          ),
          const SizedBox(height: 16),
          _buildSection(
            theme,
            colorScheme,
            'Related Hadiths',
            '${_analysis!.relatedHadiths.length} authentic hadiths',
            Icons.article,
          ),
          const SizedBox(height: 16),
          _buildSection(
            theme,
            colorScheme,
            'Thematic Connections',
            '${_analysis!.themes.length} themes identified',
            Icons.auto_awesome,
          ),
        ],
      ),
    );
  }

  Widget _buildLinguisticsTab(ThemeData theme, ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Linguistic Analysis',
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ..._analysis!.linguisticInsights.map((insight) => 
            _buildInsightCard(theme, colorScheme, insight.aspect, insight.description)
          ),
        ],
      ),
    );
  }

  Widget _buildThemesTab(ThemeData theme, ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thematic Analysis',
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ..._analysis!.themes.map((theme) => 
            _buildThemeCard(Theme.of(context), colorScheme, theme.theme, theme.description)
          ),
        ],
      ),
    );
  }

  Widget _buildHadithTab(ThemeData theme, ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Related Hadiths',
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ..._analysis!.relatedHadiths.map((hadith) => 
            _buildHadithCard(theme, colorScheme, hadith)
          ),
        ],
      ),
    );
  }

  Widget _buildContextTab(ThemeData theme, ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contextual Analysis',
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ..._analysis!.contexts.map((context) => 
            _buildContextCard(theme, colorScheme, context)
          ),
        ],
      ),
    );
  }

  Widget _buildSection(ThemeData theme, ColorScheme colorScheme, String title, String content, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: colorScheme.primary, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                content,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInsightCard(ThemeData theme, ColorScheme colorScheme, String title, String description) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeCard(ThemeData theme, ColorScheme colorScheme, String title, String description) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.auto_awesome, color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHadithCard(ThemeData theme, ColorScheme colorScheme, HadithReference hadith) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.article, color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    hadith.collection,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    hadith.grade,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              hadith.textEnglish,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              hadith.explanation,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContextCard(ThemeData theme, ColorScheme colorScheme, ContextualAnalysis context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.history_edu, color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  context.context,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              context.explanation,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            if (context.historicalBackground.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Historical Background:',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                context.historicalBackground,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
