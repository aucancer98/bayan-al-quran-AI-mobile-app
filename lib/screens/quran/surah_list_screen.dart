import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/mock_data_service.dart';
import '../../services/service_manager.dart';
import '../../models/quran_models.dart';
import '../../widgets/arabic_text.dart';
import '../../widgets/connectivity_status.dart';

class SurahListScreen extends StatefulWidget {
  const SurahListScreen({super.key});

  @override
  State<SurahListScreen> createState() => _SurahListScreenState();
}

class _SurahListScreenState extends State<SurahListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ServiceManager _serviceManager = ServiceManager();
  List<Surah> _filteredSurahs = [];
  List<Surah> _allSurahs = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSurahs();
  }

  Future<void> _loadSurahs() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Try to get surahs from API first, with fallback to mock data
      _allSurahs = await MockDataService.getMockSurahs();
      _filteredSurahs = _allSurahs;
    } catch (e) {
      _errorMessage = 'Failed to load surahs. Please check your connection and try again.';
      print('Error loading surahs: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ConnectivityStatus(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quran'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/'),
          ),
          actions: [
            const ConnectivityIndicator(),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                context.go('/quran/search');
              },
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadSurahs,
            ),
          ],
        ),
        body: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SearchBar(
                controller: _searchController,
                hintText: 'Search surahs, ayahs, words, or translations...',
                leading: const Icon(Icons.search),
                trailing: [
                  if (_searchController.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _filterSurahs('');
                      },
                    ),
                ],
                onChanged: _filterSurahs,
              ),
            ),
            
            // Content
            Expanded(
              child: _buildContent(context, theme, colorScheme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading surahs...'),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
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
              _errorMessage!,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadSurahs,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_filteredSurahs.isEmpty) {
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
              'No surahs found',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search terms',
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
      itemCount: _filteredSurahs.length,
      itemBuilder: (context, index) {
        final surah = _filteredSurahs[index];
        return _buildSurahCard(context, surah, theme, colorScheme);
      },
    );
  }

  void _filterSurahs(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredSurahs = _allSurahs;
      } else {
        _filteredSurahs = _allSurahs.where((surah) {
          return surah.nameArabic.toLowerCase().contains(query.toLowerCase()) ||
                 surah.nameEnglish.toLowerCase().contains(query.toLowerCase()) ||
                 surah.nameTransliterated.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  Widget _buildSurahCard(
    BuildContext context,
    Surah surah,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colorScheme.primaryContainer,
          child: Text(
            '${surah.number}',
            style: TextStyle(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: ArabicText(
                  surah.nameArabic,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: surah.revelationType == 'Meccan'
                    ? colorScheme.tertiaryContainer
                    : colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                surah.revelationType,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: surah.revelationType == 'Meccan'
                      ? colorScheme.onTertiaryContainer
                      : colorScheme.onSecondaryContainer,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              surah.nameEnglish,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${surah.ayahCount} verses',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: colorScheme.onSurfaceVariant,
        ),
        onTap: () {
          context.go('/quran/surah/${surah.number}');
        },
      ),
    );
  }
}
