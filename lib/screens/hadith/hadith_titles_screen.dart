import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/hadith_service.dart';
import '../../models/hadith_models.dart';
import '../../widgets/arabic_text.dart';

class HadithTitlesScreen extends StatefulWidget {
  final String collectionName;
  
  const HadithTitlesScreen({
    super.key,
    required this.collectionName,
  });

  @override
  State<HadithTitlesScreen> createState() => _HadithTitlesScreenState();
}

class _HadithTitlesScreenState extends State<HadithTitlesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Hadith> _allHadiths = [];
  List<Hadith> _filteredHadiths = [];
  List<String> _books = [];
  String _selectedBook = 'All';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHadiths();
  }

  Future<void> _loadHadiths() async {
    try {
      List<Hadith> hadiths;
      
      // Load hadiths based on collection
      if (widget.collectionName == 'Sahih Bukhari') {
        hadiths = await HadithService.getSahihBukhariHadiths();
      } else if (widget.collectionName == 'Sahih Muslim') {
        hadiths = await HadithService.getSahihMuslimHadiths();
      } else {
        hadiths = await HadithService.getAllHadiths();
      }
      
      // Filter by collection if not specific collection
      if (widget.collectionName != 'Sahih Bukhari' && widget.collectionName != 'Sahih Muslim') {
        hadiths = hadiths.where((h) => h.collection == widget.collectionName).toList();
      }
      
      // Get unique books
      final books = hadiths.map((h) => h.book).toSet().toList();
      books.sort();
      
      if (mounted) {
        setState(() {
          _allHadiths = hadiths;
          _filteredHadiths = hadiths;
          _books = ['All', ...books];
          _isLoading = false;
        });
      }
    } catch (e) {
      // Fallback to mock data
      final hadiths = HadithService.getMockHadiths();
      final filteredHadiths = hadiths.where((h) => h.collection == widget.collectionName).toList();
      final books = filteredHadiths.map((h) => h.book).toSet().toList();
      books.sort();
      
      if (mounted) {
        setState(() {
          _allHadiths = filteredHadiths;
          _filteredHadiths = filteredHadiths;
          _books = ['All', ...books];
          _isLoading = false;
        });
      }
    }
  }

  void _searchHadiths(String query) {
    setState(() {
      if (query.isEmpty) {
        _applyCurrentFilter();
      } else {
        final filteredByBook = _selectedBook == 'All' 
            ? _allHadiths 
            : _allHadiths.where((h) => h.book == _selectedBook).toList();
        
        _filteredHadiths = filteredByBook.where((hadith) {
          return hadith.textEnglish.toLowerCase().contains(query.toLowerCase()) ||
                 hadith.textArabic.contains(query) ||
                 hadith.narrator.toLowerCase().contains(query.toLowerCase()) ||
                 hadith.chapter.toLowerCase().contains(query.toLowerCase()) ||
                 hadith.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase()));
        }).toList();
      }
    });
  }

  void _filterByBook(String book) {
    setState(() {
      _selectedBook = book;
      _applyCurrentFilter();
    });
  }

  void _applyCurrentFilter() {
    if (_selectedBook == 'All') {
      _filteredHadiths = _allHadiths;
    } else {
      _filteredHadiths = _allHadiths.where((hadith) => hadith.book == _selectedBook).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.collectionName),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/hadith/books'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Open advanced search
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: colorScheme.primary,
              ),
            )
          : Column(
              children: [
                // Search and Filter Section
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Search Bar
                      SearchBar(
                        controller: _searchController,
                        hintText: 'Search hadiths...',
                        onChanged: _searchHadiths,
                        leading: Icon(
                          Icons.search,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Book Filter
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ..._books.map((book) => Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: _buildFilterChip(
                                book,
                                _selectedBook,
                                _filterByBook,
                                theme,
                                colorScheme,
                              ),
                            )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Hadiths List
                Expanded(
                  child: _filteredHadiths.isEmpty
                      ? Center(
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
                                'No hadiths found',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          itemCount: _filteredHadiths.length,
                          itemBuilder: (context, index) {
                            final hadith = _filteredHadiths[index];
                            return _buildHadithCard(hadith, theme, colorScheme);
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildFilterChip(
    String label,
    String selected,
    Function(String) onSelected,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final isSelected = selected == label;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) => onSelected(label),
      selectedColor: colorScheme.primaryContainer,
      checkmarkColor: colorScheme.onPrimaryContainer,
    );
  }

  Widget _buildHadithCard(Hadith hadith, ThemeData theme, ColorScheme colorScheme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: () => _showHadithDetail(hadith, theme, colorScheme),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      hadith.book,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
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
                  const Spacer(),
                  Text(
                    hadith.reference,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Chapter
              Text(
                hadith.chapter,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Arabic Text
              Directionality(
                textDirection: TextDirection.rtl,
                child: ArabicText(
                  hadith.textArabic,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              
              const SizedBox(height: 12),
              
              // English Text
              Text(
                hadith.textEnglish,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 12),
              
              // Footer
              Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    hadith.narrator,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
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
            ],
          ),
        ),
      ),
    );
  }

  void _showHadithDetail(Hadith hadith, ThemeData theme, ColorScheme colorScheme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              hadith.collection,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              hadith.grade,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSecondaryContainer,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Chapter
                      Text(
                        'Chapter',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        hadith.chapter,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Arabic Text
                      Text(
                        'Arabic Text',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: ArabicText(
                          hadith.textArabic,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            height: 1.8,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // English Text
                      Text(
                        'English Translation',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        hadith.textEnglish,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Details
                      _buildDetailRow('Narrator', hadith.narrator, theme, colorScheme),
                      _buildDetailRow('Book', hadith.book, theme, colorScheme),
                      _buildDetailRow('Reference', hadith.reference, theme, colorScheme),
                      
                      if (hadith.tags.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text(
                          'Tags',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: hadith.tags.map((tag) => Chip(
                            label: Text(tag),
                            backgroundColor: colorScheme.surfaceVariant,
                          )).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
