import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/mock_data_service.dart';
import '../../models/quran_models.dart';
import '../../widgets/arabic_text.dart';

class QuranSearchScreen extends StatefulWidget {
  const QuranSearchScreen({super.key});

  @override
  State<QuranSearchScreen> createState() => _QuranSearchScreenState();
}

class _QuranSearchScreenState extends State<QuranSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Ayah> _searchResults = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Quran'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/quran'),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Search in Quran...',
              leading: const Icon(Icons.search),
              trailing: [
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchResults.clear();
                        _isSearching = false;
                      });
                    },
                  ),
              ],
              onSubmitted: _performSearch,
              onChanged: (value) {
                if (value.isEmpty) {
                  setState(() {
                    _searchResults.clear();
                    _isSearching = false;
                  });
                }
              },
            ),
          ),
          
          // Search results
          Expanded(
            child: _buildSearchResults(theme, colorScheme),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(ThemeData theme, ColorScheme colorScheme) {
    if (!_isSearching && _searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_outlined,
              size: 64,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'Search in the Quran',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter a word or phrase to search\nacross all verses',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (_isSearching) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No results found',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try different keywords or check spelling',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final ayah = _searchResults[index];
        return _buildSearchResultCard(ayah, theme, colorScheme);
      },
    );
  }

  Widget _buildSearchResultCard(Ayah ayah, ThemeData theme, ColorScheme colorScheme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: () {
          context.go('/quran/surah/${ayah.surahNumber}');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ayah header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Surah ${ayah.surahNumber}, Ayah ${ayah.ayahNumber}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Arabic text
              Directionality(
                textDirection: TextDirection.rtl,
                child: ArabicText(
                  ayah.arabicText,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              const SizedBox(height: 8),
              
              // Translation
              Text(
                ayah.translations.first.text,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) return;

    setState(() {
      _isSearching = true;
    });

    // Perform comprehensive search across all surahs
    Future.delayed(const Duration(milliseconds: 500), () async {
      final results = <Ayah>[];
      final surahs = await MockDataService.getMockSurahs();
      
      // Search across all surahs
      for (final surah in surahs) {
        try {
          final ayahs = await MockDataService.getAyahsForSurah(surah.number);
          
          for (final ayah in ayahs) {
            bool found = false;
            
            // Search in Arabic text
            if (ayah.arabicText.toLowerCase().contains(query.toLowerCase())) {
              found = true;
            }
            
            // Search in translation text
            if (!found && ayah.translations.any((translation) => 
                translation.text.toLowerCase().contains(query.toLowerCase()))) {
              found = true;
            }
            
            // Search in individual words
            if (!found && ayah.words.any((word) => 
                word.arabic.toLowerCase().contains(query.toLowerCase()) ||
                word.transliteration.toLowerCase().contains(query.toLowerCase()) ||
                word.meaning.toLowerCase().contains(query.toLowerCase()) ||
                word.contextualMeaning.toLowerCase().contains(query.toLowerCase()) ||
                word.root.toLowerCase().contains(query.toLowerCase()))) {
              found = true;
            }
            
            // Search in surah names
            if (!found) {
              if (surah.nameArabic.toLowerCase().contains(query.toLowerCase()) ||
                  surah.nameEnglish.toLowerCase().contains(query.toLowerCase()) ||
                  surah.nameTransliterated.toLowerCase().contains(query.toLowerCase())) {
                found = true;
              }
            }
            
            if (found) {
              results.add(ayah);
            }
          }
        } catch (e) {
          // Continue searching other surahs if one fails
          print('Error searching surah ${surah.number}: $e');
        }
      }

      if (mounted) {
        setState(() {
          _searchResults = results;
          _isSearching = false;
        });
      }
    });
  }
}
