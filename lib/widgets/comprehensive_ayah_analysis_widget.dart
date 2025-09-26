import 'package:flutter/material.dart';
import '../services/ayah_analysis_service.dart';
import '../services/ayah_similarity_service.dart';

/// Widget for displaying comprehensive ayah analysis with multiple tafsirs and ahadith
class ComprehensiveAyahAnalysisWidget extends StatefulWidget {
  final int surahNumber;
  final int ayahNumber;
  final String? arabicText;
  final String? englishText;
  final VoidCallback? onClose;

  const ComprehensiveAyahAnalysisWidget({
    super.key,
    required this.surahNumber,
    required this.ayahNumber,
    this.arabicText,
    this.englishText,
    this.onClose,
  });

  @override
  State<ComprehensiveAyahAnalysisWidget> createState() => _ComprehensiveAyahAnalysisWidgetState();
}

class _ComprehensiveAyahAnalysisWidgetState extends State<ComprehensiveAyahAnalysisWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ComprehensiveAyahAnalysis? _analysis;
  bool _isLoading = true;
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
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final analysis = await AyahAnalysisService.getAyahAnalysis(
        surahNumber: widget.surahNumber,
        ayahNumber: widget.ayahNumber,
        arabicText: widget.arabicText ?? 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        englishText: widget.englishText ?? 'In the name of Allah, the Entirely Merciful, the Especially Merciful.',
      );

      if (mounted) {
        setState(() {
          _analysis = analysis;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          _buildHeader(theme, colorScheme),
          
          // Tab Bar
          _buildTabBar(theme, colorScheme),
          
          // Content
          Expanded(
            child: _buildContent(theme, colorScheme),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.analytics_outlined,
            color: colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Comprehensive Analysis',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                Text(
                  'Surah ${widget.surahNumber}, Ayah ${widget.ayahNumber}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: widget.onClose,
            icon: Icon(
              Icons.close,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      color: colorScheme.surface,
      child: TabBar(
        controller: _tabController,
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurface.withOpacity(0.6),
        indicatorColor: colorScheme.primary,
        tabs: const [
          Tab(text: 'Summary', icon: Icon(Icons.summarize, size: 18)),
          Tab(text: 'Tafsir', icon: Icon(Icons.menu_book, size: 18)),
          Tab(text: 'Ahadith', icon: Icon(Icons.record_voice_over, size: 18)),
          Tab(text: 'Similar', icon: Icon(Icons.compare_arrows, size: 18)),
          Tab(text: 'Context', icon: Icon(Icons.history_edu, size: 18)),
        ],
      ),
    );
  }

  Widget _buildContent(ThemeData theme, ColorScheme colorScheme) {
    if (_isLoading) {
      return _buildLoadingState(theme, colorScheme);
    }

    if (_error != null) {
      return _buildErrorState(theme, colorScheme);
    }

    if (_analysis == null) {
      return _buildEmptyState(theme, colorScheme);
    }

    return TabBarView(
      controller: _tabController,
      children: [
        _buildSummaryTab(theme, colorScheme),
        _buildTafsirTab(theme, colorScheme),
        _buildAhadithTab(theme, colorScheme),
        _buildSimilarAyahsTab(theme, colorScheme),
        _buildContextTab(theme, colorScheme),
      ],
    );
  }

  Widget _buildLoadingState(ThemeData theme, ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            'Loading comprehensive analysis...',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme, ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load analysis',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.error,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _error ?? 'Unknown error',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadAnalysis,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            size: 64,
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
          const SizedBox(height: 16),
          Text(
            'No analysis available',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Analysis data is not available for this ayah.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryTab(ThemeData theme, ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Analysis Summary
          _buildSection(
            title: 'Analysis Summary',
            icon: Icons.analytics,
            theme: theme,
            colorScheme: colorScheme,
            child: Text(
              _analysis!.analysisSummary,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.6,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Key Themes
          _buildSection(
            title: 'Key Themes',
            icon: Icons.label_important,
            theme: theme,
            colorScheme: colorScheme,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _analysis!.keyThemes.map((theme) => Chip(
                label: Text(theme),
                backgroundColor: colorScheme.primaryContainer,
                labelStyle: TextStyle(color: colorScheme.onPrimaryContainer),
              )).toList(),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Statistics
          _buildSection(
            title: 'Analysis Statistics',
            icon: Icons.assessment,
            theme: theme,
            colorScheme: colorScheme,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Tafsir Sources',
                        '${_analysis!.tafsirSources.length}',
                        Icons.menu_book,
                        theme,
                        colorScheme,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Relevant Ahadith',
                        '${_analysis!.relevantAhadith.length}',
                        Icons.record_voice_over,
                        theme,
                        colorScheme,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Similar Ayahs',
                        '${_analysis!.similarAyahs.length}',
                        Icons.compare_arrows,
                        theme,
                        colorScheme,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTafsirTab(ThemeData theme, ColorScheme colorScheme) {
    if (_analysis!.tafsirSources.isEmpty) {
      return Center(
        child: Text(
          'No tafsir sources available for this ayah.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _analysis!.tafsirSources.length,
      itemBuilder: (context, index) {
        final source = _analysis!.tafsirSources[index];
        return _buildTafsirSourceCard(source, theme, colorScheme);
      },
    );
  }

  Widget _buildAhadithTab(ThemeData theme, ColorScheme colorScheme) {
    if (_analysis!.relevantAhadith.isEmpty) {
      return Center(
        child: Text(
          'No relevant ahadith found for this ayah.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _analysis!.relevantAhadith.length,
      itemBuilder: (context, index) {
        final relevantHadith = _analysis!.relevantAhadith[index];
        return _buildHadithCard(relevantHadith, theme, colorScheme);
      },
    );
  }

  Widget _buildSimilarAyahsTab(ThemeData theme, ColorScheme colorScheme) {
    if (_analysis!.similarAyahs.isEmpty) {
      return Center(
        child: Text(
          'No similar ayahs found for this verse.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _analysis!.similarAyahs.length,
      itemBuilder: (context, index) {
        final similarAyah = _analysis!.similarAyahs[index];
        return _buildSimilarAyahCard(similarAyah, theme, colorScheme);
      },
    );
  }

  Widget _buildContextTab(ThemeData theme, ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Historical Context
          _buildSection(
            title: 'Historical Context',
            icon: Icons.history,
            theme: theme,
            colorScheme: colorScheme,
            child: Text(
              _analysis!.historicalContext,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.6,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Revelation Context
          _buildSection(
            title: 'Revelation Context',
            icon: Icons.auto_stories,
            theme: theme,
            colorScheme: colorScheme,
            child: Text(
              'This ayah was revealed during the period of Islamic revelation and contains important guidance for believers. The context of revelation provides important insights into the meaning and application of this verse.',
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.6,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required ThemeData theme,
    required ColorScheme colorScheme,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: colorScheme.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: colorScheme.primary, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTafsirSourceCard(
    TafsirSource source,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    source.author,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    source.source,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              source.commentary,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.6,
                color: colorScheme.onSurface,
              ),
            ),
            if (source.keyPoints.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Key Points:',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              ...source.keyPoints.map((point) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        point,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHadithCard(
    RelevantHadith relevantHadith,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final hadith = relevantHadith.hadith;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.record_voice_over,
                  color: colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    hadith.reference,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getGradeColor(hadith.grade, colorScheme),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    hadith.grade,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              relevantHadith.connectionType,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.primary,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              hadith.textEnglish,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.6,
                color: colorScheme.onSurface,
              ),
            ),
            if (hadith.context.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Context:',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hadith.context,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSimilarAyahCard(
    SimilarAyah similarAyah,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _navigateToSimilarAyah(similarAyah),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.compare_arrows,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${similarAyah.surahName} ${similarAyah.ayahNumber}',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getSimilarityColor(similarAyah.similarityScore, colorScheme),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${(similarAyah.similarityScore * 100).toInt()}%',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                similarAyah.similarityType,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 12),
              // Arabic text
              Text(
                similarAyah.arabicText,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 8),
              // English text
              Text(
                similarAyah.englishText,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Connection:',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      similarAyah.connectionReason,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToSimilarAyah(SimilarAyah similarAyah) {
    // Close current modal
    Navigator.of(context).pop();
    
    // Navigate to the similar ayah
    // This would need to be implemented based on your navigation system
    // For now, we'll show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigate to ${similarAyah.surahName} ${similarAyah.ayahNumber}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Color _getSimilarityColor(double score, ColorScheme colorScheme) {
    if (score >= 0.8) return Colors.green;
    if (score >= 0.6) return Colors.blue;
    if (score >= 0.4) return Colors.orange;
    return colorScheme.primary;
  }

  Color _getGradeColor(String grade, ColorScheme colorScheme) {
    switch (grade.toLowerCase()) {
      case 'sahih':
        return Colors.green;
      case 'hasan':
        return Colors.blue;
      case 'daif':
        return Colors.orange;
      default:
        return colorScheme.primary;
    }
  }
}
