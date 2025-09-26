import 'package:flutter/material.dart';
import '../models/quran_models.dart';
import '../widgets/arabic_text.dart';
import 'ai_insights_widget.dart';

class WordDetailModal extends StatelessWidget {
  final Word word;
  final ThemeData theme;
  final ColorScheme colorScheme;

  const WordDetailModal({
    super.key,
    required this.word,
    required this.theme,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colorScheme.onSurfaceVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Word header
                _buildWordHeader(),
                const SizedBox(height: 24),
                
                // Root word analysis
                _buildRootAnalysis(),
                const SizedBox(height: 20),
                
                // Meanings
                _buildMeanings(),
                const SizedBox(height: 20),
                
                // Grammar information
                _buildGrammarInfo(),
                const SizedBox(height: 20),
                
                // Related words
                _buildRelatedWords(),
                const SizedBox(height: 20),
                
                // Semantic Analysis
                _buildSemanticAnalysis(),
                const SizedBox(height: 20),
                
                // AI Insights
                _buildAIInsights(),
                const SizedBox(height: 20),
                
                // Close button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWordHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Directionality(
            textDirection: TextDirection.rtl,
            child: ArabicText(
              word.arabic,
              style: theme.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onPrimaryContainer,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            word.transliteration,
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onPrimaryContainer,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRootAnalysis() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.eco_outlined,
                  color: colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Root Word',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Directionality(
              textDirection: TextDirection.rtl,
              child: ArabicText(
                word.root,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _getRootWordMeaning(word.root),
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

  Widget _buildMeanings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.translate_outlined,
                  color: colorScheme.secondary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Meanings',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Individual meaning
            _buildMeaningItem(
              'Individual Meaning',
              word.meaning,
              Icons.text_fields_outlined,
            ),
            const SizedBox(height: 12),
            
            // Contextual meaning
            _buildMeaningItem(
              'Contextual Meaning',
              word.contextualMeaning,
              Icons.psychology_outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeaningItem(String title, String meaning, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          meaning,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildGrammarInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.school_outlined,
                  color: colorScheme.tertiary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Grammar Information',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.tertiary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildGrammarItem('Part of Speech', word.partOfSpeech),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildGrammarItem('Grammar', word.grammar),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrammarItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRelatedWords() {
    if (word.relatedWords.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.link_outlined,
                  color: colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Related Words',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: word.relatedWords.map((relatedWord) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ArabicText(
                      relatedWord,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getRootWordMeaning(String root) {
    // Map of common Arabic root words and their meanings
    final rootMeanings = {
      'ر ح م': 'Mercy, compassion, kindness',
      'أ ل ه': 'God, deity, divinity',
      'س م و': 'Name, naming, designation',
      'ح م د': 'Praise, commendation, gratitude',
      'ر ب ب': 'Lord, master, sustainer',
      'ع ل م': 'Knowledge, science, awareness',
      'م ل ك': 'Kingdom, dominion, ownership',
      'ي و م': 'Day, time, period',
      'د ي ن': 'Religion, faith, judgment',
      'ع ب د': 'Worship, service, devotion',
      'ع و ن': 'Help, assistance, support',
      'ه د ي': 'Guidance, direction, leading',
      'ص ر ط': 'Path, way, road',
      'ق و م': 'Stand, establish, straighten',
      'ذ ل ك': 'That, those (demonstrative)',
      'ك ت ب': 'Write, book, scripture',
      'ر ي ب': 'Doubt, suspicion, uncertainty',
      'و ق ي': 'Fear, consciousness, awareness',
      'أ ي ي': 'Which, what (relative pronoun)',
      'غ ض ب': 'Anger, wrath, displeasure',
      'ض ل ل': 'Stray, error, misguidance',
      'أ ل م': 'Alif Lam Mim (mysterious letters)',
      'م ث ل': 'Example, parable, likeness',
    };

    // Return the meaning if found, otherwise provide a generic description
    return rootMeanings[root] ?? 'Root letters: $root';
  }

  Widget _buildSemanticAnalysis() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.psychology_outlined,
                  color: colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Semantic Analysis',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'AI',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Understanding word meaning through semantic similarity and context',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            AIInsightsWidget(
              word: word.transliteration,
              arabic: word.arabic,
              context: 'Word position ${word.position}',
              showHadith: true,
              showThemes: true,
              showLinguistics: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIInsights() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.psychology,
                  color: colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'AI-Powered Analysis',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'NEW',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Get comprehensive analysis across the entire Quran and authentic Hadith collections',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            AIInsightsWidget(
              word: word.transliteration,
              arabic: word.arabic,
              showHadith: true,
              showThemes: true,
              showLinguistics: true,
            ),
          ],
        ),
      ),
    );
  }
}
