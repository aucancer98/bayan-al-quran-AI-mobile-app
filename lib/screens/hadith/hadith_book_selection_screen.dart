import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/hadith_service.dart';
import '../../models/hadith_models.dart';

class HadithBookSelectionScreen extends StatefulWidget {
  const HadithBookSelectionScreen({super.key});

  @override
  State<HadithBookSelectionScreen> createState() => _HadithBookSelectionScreenState();
}

class _HadithBookSelectionScreenState extends State<HadithBookSelectionScreen> {
  List<HadithCollection> _collections = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCollections();
  }

  Future<void> _loadCollections() async {
    try {
      final collections = await HadithService.getHadithCollections();
      if (mounted) {
        setState(() {
          _collections = collections;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Hadith Collection'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/hadith'),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: colorScheme.primary,
              ),
            )
          : _collections.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.book_outlined,
                        size: 64,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No collections available',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _collections.length,
                  itemBuilder: (context, index) {
                    final collection = _collections[index];
                    return _buildCollectionCard(collection, theme, colorScheme);
                  },
                ),
    );
  }

  Widget _buildCollectionCard(
    HadithCollection collection,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () => _navigateToBookList(collection),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.menu_book,
                      color: colorScheme.onPrimaryContainer,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          collection.name,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'by ${collection.author}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Description
              Text(
                collection.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                  color: colorScheme.onSurface,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Stats
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.format_list_numbered,
                          size: 16,
                          color: colorScheme.onSecondaryContainer,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${collection.totalHadiths} Hadiths',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSecondaryContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: colorScheme.tertiaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.language,
                          size: 16,
                          color: colorScheme.onTertiaryContainer,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          collection.language,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onTertiaryContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToBookList(HadithCollection collection) {
    context.go('/hadith/books/${collection.name}');
  }
}
