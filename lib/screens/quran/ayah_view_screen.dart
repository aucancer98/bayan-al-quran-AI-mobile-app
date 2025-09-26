import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/mock_data_service.dart';
import '../../services/bookmark_service.dart';
import '../../models/quran_models.dart';
import '../../widgets/arabic_text.dart';
import '../../widgets/word_detail_modal.dart';
import '../../widgets/comprehensive_ayah_analysis_widget.dart';

class AyahViewScreen extends StatefulWidget {
  final int surahNumber;
  
  const AyahViewScreen({
    super.key,
    required this.surahNumber,
  });

  @override
  State<AyahViewScreen> createState() => _AyahViewScreenState();
}

class _AyahViewScreenState extends State<AyahViewScreen> {
  int currentAyahIndex = 0;
  List<Ayah> ayahs = [];
  bool isLoading = true;
  bool isBookmarked = false;
  String surahName = '';

  @override
  void initState() {
    super.initState();
    _loadAyahs();
  }

  Future<void> _loadAyahs() async {
    try {
      // Load ayahs for the specific surah number
      ayahs = await MockDataService.getAyahsForSurah(widget.surahNumber);
      
      // Load surah information
      final surahs = await MockDataService.getMockSurahs();
      final surah = surahs.firstWhere(
        (s) => s.number == widget.surahNumber,
        orElse: () => surahs.first,
      );
      surahName = surah.nameEnglish;
      
      // Check bookmark status for current ayah
      await _checkBookmarkStatus();
      
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      // Fallback to mock data
      ayahs = MockDataService.getMockAyahs();
      surahName = 'Surah ${widget.surahNumber}';
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _checkBookmarkStatus() async {
    if (ayahs.isNotEmpty) {
      final currentAyah = ayahs[currentAyahIndex];
      isBookmarked = await BookmarkService.isBookmarked(
        currentAyah.surahNumber,
        currentAyah.ayahNumber,
      );
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Surah ${widget.surahNumber}'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/quran'),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (ayahs.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Surah ${widget.surahNumber}'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/quran'),
          ),
        ),
        body: const Center(
          child: Text('No ayahs found'),
        ),
      );
    }

    final currentAyah = ayahs[currentAyahIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(surahName.isNotEmpty ? surahName : 'Surah ${widget.surahNumber}'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/quran'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            onPressed: _showComprehensiveAnalysis,
            tooltip: 'Comprehensive Analysis',
          ),
          IconButton(
            icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_outline),
            onPressed: _toggleBookmark,
          ),
        ],
      ),
      body: Column(
        children: [
          // Ayah navigation
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: currentAyahIndex > 0 ? _previousAyah : null,
                  icon: const Icon(Icons.chevron_left),
                ),
                Text(
                  'Ayah ${currentAyah.ayahNumber}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: currentAyahIndex < ayahs.length - 1 ? _nextAyah : null,
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
          
          // Ayah content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Arabic text with word-by-word interactivity
                  _buildArabicText(currentAyah, theme, colorScheme),
                  
                  const SizedBox(height: 24),
                  
                  // Translation
                  _buildTranslation(currentAyah, theme, colorScheme),
                  
                  const SizedBox(height: 24),
                  
                  // Ayah info
                  _buildAyahInfo(currentAyah, theme, colorScheme),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArabicText(Ayah ayah, ThemeData theme, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.end,
                crossAxisAlignment: WrapCrossAlignment.end,
                runAlignment: WrapAlignment.end,
                textDirection: TextDirection.rtl,
                children: ayah.words.map((word) {
                  return _buildClickableWord(word, theme, colorScheme);
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClickableWord(Word word, ThemeData theme, ColorScheme colorScheme) {
    return GestureDetector(
      onTap: () {
        _showWordDetail(word, theme, colorScheme);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: colorScheme.surfaceVariant.withOpacity(0.3),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Arabic word
            ArabicText(
              word.arabic,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 2),
            // Transliteration
            Text(
              word.transliteration,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.primary,
                fontSize: 9,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 1),
            // Word meaning
            Text(
              word.meaning,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: 9,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTranslation(Ayah ayah, ThemeData theme, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.translate,
                  color: colorScheme.secondary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Translation',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.secondary,
                  ),
                ),
                const Spacer(),
                Text(
                  ayah.translations.first.translator,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              ayah.translations.first.text,
              style: theme.textTheme.bodyLarge?.copyWith(
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAyahInfo(Ayah ayah, ThemeData theme, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ayah Information',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.tertiary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem('Juz', '${ayah.juz}', theme, colorScheme),
                ),
                Expanded(
                  child: _buildInfoItem('Hizb', '${ayah.hizb}', theme, colorScheme),
                ),
                Expanded(
                  child: _buildInfoItem('Rub', '${ayah.rub}', theme, colorScheme),
                ),
              ],
            ),
            if (ayah.tafsir.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildTafsirSection(ayah.tafsir, theme, colorScheme),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.tertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildTafsirSection(String tafsir, ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.menu_book_outlined,
              color: colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Tafsir (Commentary)',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.surfaceVariant.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: colorScheme.outline.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Text(
            tafsir,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.6,
              color: colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  void _showWordDetail(Word word, ThemeData theme, ColorScheme colorScheme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WordDetailModal(
        word: word,
        theme: theme,
        colorScheme: colorScheme,
      ),
    );
  }

  void _previousAyah() {
    if (currentAyahIndex > 0) {
      setState(() {
        currentAyahIndex--;
      });
      _checkBookmarkStatus();
    }
  }

  void _nextAyah() {
    if (currentAyahIndex < ayahs.length - 1) {
      setState(() {
        currentAyahIndex++;
      });
      _checkBookmarkStatus();
    }
  }

  Future<void> _toggleBookmark() async {
    if (ayahs.isEmpty) return;
    
    final currentAyah = ayahs[currentAyahIndex];
    
    if (isBookmarked) {
      // Remove bookmark
      await BookmarkService.removeBookmark(
        currentAyah.surahNumber,
        currentAyah.ayahNumber,
      );
    } else {
      // Add bookmark
      final bookmark = Bookmark(
        surahNumber: currentAyah.surahNumber,
        ayahNumber: currentAyah.ayahNumber,
        surahName: surahName,
        ayahText: currentAyah.arabicText,
        createdAt: DateTime.now(),
      );
      await BookmarkService.addBookmark(bookmark);
    }
    
    setState(() {
      isBookmarked = !isBookmarked;
    });
    
    // Show feedback
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isBookmarked 
              ? 'Ayah bookmarked successfully' 
              : 'Bookmark removed',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showComprehensiveAnalysis() {
    final currentAyah = ayahs[currentAyahIndex];
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ComprehensiveAyahAnalysisWidget(
        surahNumber: widget.surahNumber,
        ayahNumber: currentAyah.ayahNumber,
        arabicText: currentAyah.arabicText,
        englishText: currentAyah.translations.isNotEmpty ? currentAyah.translations.first.text : '',
        onClose: () => Navigator.of(context).pop(),
      ),
    );
  }
}
