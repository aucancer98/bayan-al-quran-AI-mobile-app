import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/hadith_service.dart';
import '../../services/ai/openrouter_semantic_service.dart';
import '../../models/hadith_models.dart';
import '../../widgets/arabic_text.dart';

class HadithScreen extends StatefulWidget {
  const HadithScreen({super.key});

  @override
  State<HadithScreen> createState() => _HadithScreenState();
}

class _HadithScreenState extends State<HadithScreen> {
  final TextEditingController _searchController = TextEditingController();
  final OpenRouterSemanticService _semanticService = OpenRouterSemanticService();
  
  List<Hadith> _allHadiths = [];
  List<Hadith> _hadiths = [];
  List<HadithCollection> _collections = [];
  List<String> _allBooks = [];
  String _selectedCollection = 'All';
  bool _isLoading = true;
  bool _showBooks = true; // Show books by default
  
  // Semantic search state
  bool _isSemanticSearch = false;
  List<Hadith> _semanticResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadData();
    _initializeSemanticService();
  }
  
  Future<void> _initializeSemanticService() async {
    try {
      await _semanticService.initialize();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Semantic search unavailable: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _loadData() async {
    try {
      final hadiths = await HadithService.getAllHadiths();
      final collections = await HadithService.getHadithCollections();
      if (mounted) {
        setState(() {
          _allHadiths = hadiths;
          _collections = collections;
          // Get all unique books from all collections
          _allBooks = hadiths.map((h) => h.book).toSet().toList();
          _allBooks.sort();
          _applyCurrentFilter();
          _isLoading = false;
        });
      }
    } catch (e) {
      // Fallback to mock data if JSON loading fails
      if (mounted) {
        final collections = await HadithService.getHadithCollections();
        final mockHadiths = HadithService.getMockHadiths();
        setState(() {
          _allHadiths = mockHadiths;
          _collections = collections;
          // Get all unique books from mock data
          _allBooks = mockHadiths.map((h) => h.book).toSet().toList();
          _allBooks.sort();
          _applyCurrentFilter();
          _isLoading = false;
        });
      }
    }
  }

  void _searchHadiths(String query) {
    setState(() {
      if (query.isEmpty) {
        _applyCurrentFilter();
        _isSemanticSearch = false;
        _semanticResults.clear();
      } else {
        _performSearch(query);
      }
    });
  }
  
  Future<void> _performSearch(String query) async {
    setState(() {
      _isSearching = true;
    });
    
    try {
      if (_isSemanticSearch) {
        // Perform semantic search using OpenRouter
        final filteredHadiths = _selectedCollection == 'All' 
            ? _allHadiths 
            : _allHadiths.where((h) => h.collection == _selectedCollection).toList();
        
        // Convert hadiths to content list for semantic search
        final contentList = filteredHadiths.map((h) => {
          'title': h.reference,
          'content': '${h.textArabic}\n${h.textEnglish}',
          'hadith': h,
        }).toList();
        
        final results = await _semanticService.searchSimilarContent(
          query: query,
          contentList: contentList,
          maxResults: 20,
        );
        
        setState(() {
          _semanticResults = results.map((r) => r['hadith'] as Hadith).toList();
          _isSearching = false;
        });
      } else {
        // Perform traditional text search
        final filteredHadiths = _selectedCollection == 'All' 
            ? _allHadiths 
            : _allHadiths.where((h) => h.collection == _selectedCollection).toList();
        
        _hadiths = filteredHadiths.where((hadith) {
          return hadith.textEnglish.toLowerCase().contains(query.toLowerCase()) ||
                 hadith.textArabic.contains(query) ||
                 hadith.narrator.toLowerCase().contains(query.toLowerCase()) ||
                 hadith.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase()));
        }).toList();
        
        setState(() {
          _isSearching = false;
        });
      }
    } catch (e) {
      setState(() {
        _isSearching = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Search failed: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
  
  void _toggleSearchMode() {
    setState(() {
      _isSemanticSearch = !_isSemanticSearch;
      if (_searchController.text.isNotEmpty) {
        _performSearch(_searchController.text);
      }
    });
  }

  void _filterByCollection(String collection) {
    setState(() {
      _selectedCollection = collection;
      _applyCurrentFilter();
    });
  }

  void _applyCurrentFilter() {
    if (_selectedCollection == 'All') {
      _hadiths = _allHadiths;
    } else {
      _hadiths = _allHadiths.where((hadith) => hadith.collection == _selectedCollection).toList();
    }
  }

  void _toggleView() {
    setState(() {
      _showBooks = !_showBooks;
    });
  }

  void _selectBook(String bookName) {
    setState(() {
      _hadiths = _allHadiths.where((hadith) => hadith.book == bookName).toList();
      _showBooks = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ahadith'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        actions: [
          IconButton(
            icon: Icon(_showBooks ? Icons.list : Icons.menu_book),
            onPressed: _toggleView,
            tooltip: _showBooks ? 'Show Hadiths' : 'Show Books',
          ),
          IconButton(
            icon: Icon(_isSemanticSearch ? Icons.psychology : Icons.search),
            onPressed: _toggleSearchMode,
            tooltip: _isSemanticSearch ? 'Switch to Text Search' : 'Switch to Semantic Search',
          ),
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
          : _showBooks
              ? _buildBooksView(theme, colorScheme)
              : _buildHadithsView(theme, colorScheme),
    );
  }

  Widget _buildBooksView(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Select a Book to Read',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Choose from ${_allBooks.length} available books',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        
        // Books Grid
        Expanded(
          child: _allBooks.isEmpty
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
                        'No books available',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _allBooks.length,
                  itemBuilder: (context, index) {
                    final bookName = _allBooks[index];
                    return _buildBookCard(bookName, theme, colorScheme);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildHadithsView(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        // Search and Filter Section
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search Bar
              SearchBar(
                controller: _searchController,
                hintText: _isSemanticSearch 
                    ? 'Search by meaning (semantic)...' 
                    : 'Search hadiths...',
                onChanged: _searchHadiths,
                leading: Icon(
                  _isSemanticSearch ? Icons.psychology : Icons.search,
                  color: colorScheme.onSurfaceVariant,
                ),
                trailing: [
                  if (_isSearching)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.primary,
                        ),
                      ),
                    )
                  else
                    IconButton(
                      icon: Icon(
                        _isSemanticSearch ? Icons.psychology : Icons.search,
                        color: _isSemanticSearch 
                            ? colorScheme.primary 
                            : colorScheme.onSurfaceVariant,
                      ),
                      onPressed: _toggleSearchMode,
                      tooltip: _isSemanticSearch 
                          ? 'Semantic Search Active' 
                          : 'Switch to Semantic Search',
                    ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Collection Filter
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('All', _selectedCollection, _filterByCollection, theme, colorScheme),
                    const SizedBox(width: 8),
                    ..._collections.map((collection) => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: _buildFilterChip(
                        collection.name,
                        _selectedCollection,
                        _filterByCollection,
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
          child: _isSemanticSearch 
              ? _buildSemanticSearchResults(theme, colorScheme)
              : _buildTraditionalSearchResults(theme, colorScheme),
        ),
      ],
    );
  }

  Widget _buildSemanticSearchResults(ThemeData theme, ColorScheme colorScheme) {
    if (_isSearching) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Searching by meaning...',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }
    
    if (_semanticResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.psychology_outlined,
              size: 64,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No semantically similar hadiths found',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try different keywords or switch to text search',
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
      itemCount: _semanticResults.length,
      itemBuilder: (context, index) {
        final result = _semanticResults[index];
        return _buildSemanticHadithCard(result, theme, colorScheme);
      },
    );
  }
  
  Widget _buildTraditionalSearchResults(ThemeData theme, ColorScheme colorScheme) {
    if (_hadiths.isEmpty) {
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
              'No hadiths found',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: _hadiths.length,
      itemBuilder: (context, index) {
        final hadith = _hadiths[index];
        return _buildHadithCard(hadith, theme, colorScheme);
      },
    );
  }

  Widget _buildBookCard(String bookName, ThemeData theme, ColorScheme colorScheme) {
    // Get hadiths for this book to show count
    final bookHadiths = _allHadiths.where((h) => h.book == bookName).toList();
    final hadithCount = bookHadiths.length;
    
    return Card(
      child: InkWell(
        onTap: () => _selectBook(bookName),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
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
              
              const SizedBox(height: 12),
              
              // Book Name
              Text(
                bookName,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const Spacer(),
              
              // Hadith Count
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$hadithCount Hadiths',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
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

  Widget _buildSemanticHadithCard(Hadith hadith, ThemeData theme, ColorScheme colorScheme) {
    
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
              // Header with similarity score
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      hadith.collection,
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
                  // AI Match indicator
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.psychology,
                          size: 14,
                          color: colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'AI Match',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
              
              // Semantic match info
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.psychology_outlined,
                      size: 16,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'AI-powered semantic match',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
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
                  Text(
                    hadith.reference,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 8),
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
                      hadith.collection,
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
                      _buildDetailRow('Chapter', hadith.chapter, theme, colorScheme),
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