import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/supplication_service.dart';
import '../../models/supplication_models.dart';
import '../../widgets/arabic_text.dart';

class SupplicationsScreen extends StatefulWidget {
  const SupplicationsScreen({super.key});

  @override
  State<SupplicationsScreen> createState() => _SupplicationsScreenState();
}

class _SupplicationsScreenState extends State<SupplicationsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Supplication> _allSupplications = [];
  List<Supplication> _supplications = [];
  List<SupplicationCategory> _categories = [];
  String _selectedCategory = 'All';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await SupplicationService.getSupplicationData();
      final supplications = (data['supplications'] as List<dynamic>)
          .map((json) => Supplication.fromJson(json))
          .toList();
      final categories = (data['categories'] as List<dynamic>)
          .map((json) => SupplicationCategory.fromJson(json))
          .toList();
      
      if (mounted) {
        setState(() {
          _allSupplications = supplications;
          _categories = categories;
          _applyCurrentFilter();
          _isLoading = false;
        });
      }
    } catch (e) {
      // Fallback to mock data if JSON loading fails
      if (mounted) {
        setState(() {
          _allSupplications = SupplicationService.getMockSupplications();
          _categories = SupplicationService.getCategories();
          _applyCurrentFilter();
          _isLoading = false;
        });
      }
    }
  }

  void _searchSupplications(String query) {
    setState(() {
      if (query.isEmpty) {
        _applyCurrentFilter();
      } else {
        final filteredSupplications = _selectedCategory == 'All' 
            ? _allSupplications 
            : _allSupplications.where((s) => s.category == _selectedCategory).toList();
        
        _supplications = filteredSupplications.where((supplication) {
          return supplication.title.toLowerCase().contains(query.toLowerCase()) ||
                 supplication.englishText.toLowerCase().contains(query.toLowerCase()) ||
                 supplication.arabicText.contains(query) ||
                 supplication.category.toLowerCase().contains(query.toLowerCase()) ||
                 supplication.context.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _applyCurrentFilter();
    });
  }

  void _applyCurrentFilter() {
    if (_selectedCategory == 'All') {
      _supplications = _allSupplications;
    } else {
      _supplications = _allSupplications.where((supplication) => supplication.category == _selectedCategory).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Supplications'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_outline),
            onPressed: () {
              // TODO: Show favorites
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
                        hintText: 'Search supplications...',
                        onChanged: _searchSupplications,
                        leading: Icon(
                          Icons.search,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Category Filter
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterChip('All', _selectedCategory, _filterByCategory, theme, colorScheme),
                            const SizedBox(width: 8),
                            ..._categories.map((category) => Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: _buildFilterChip(
                                category.name,
                                _selectedCategory,
                                _filterByCategory,
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
                
                // Supplications List
                Expanded(
                  child: _supplications.isEmpty
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
                                'No supplications found',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          itemCount: _supplications.length,
                          itemBuilder: (context, index) {
                            final supplication = _supplications[index];
                            return _buildSupplicationCard(supplication, theme, colorScheme);
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

  Widget _buildSupplicationCard(Supplication supplication, ThemeData theme, ColorScheme colorScheme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: () => _showSupplicationDetail(supplication, theme, colorScheme),
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
                      supplication.category,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (supplication.repetition > 1)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${supplication.repetition}x',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  const Spacer(),
                  Icon(
                    Icons.favorite_border,
                    size: 20,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Title
              Text(
                supplication.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Arabic Text
              Directionality(
                textDirection: TextDirection.rtl,
                child: ArabicText(
                  supplication.arabicText,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // English Text
              Text(
                supplication.englishText,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 12),
              
              // Context
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      supplication.context,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
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

  void _showSupplicationDetail(Supplication supplication, ThemeData theme, ColorScheme colorScheme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.6,
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
                              supplication.category,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (supplication.repetition > 1)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: colorScheme.secondaryContainer,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                'Repeat ${supplication.repetition} times',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSecondaryContainer,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Title
                      Text(
                        supplication.title,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
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
                          supplication.arabicText,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            height: 1.8,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Transliteration
                      Text(
                        'Transliteration',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          supplication.transliteration,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                            height: 1.5,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
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
                        supplication.englishText,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Context
                      _buildDetailRow('Context', supplication.context, theme, colorScheme),
                      _buildDetailRow('Reference', supplication.reference, theme, colorScheme),
                      
                      if (supplication.benefits.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text(
                          'Benefits',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...supplication.benefits.map((benefit) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                size: 16,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  benefit,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        )),
                      ],
                      
                      const SizedBox(height: 20),
                      
                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // TODO: Add to favorites
                              },
                              icon: const Icon(Icons.favorite_border),
                              label: const Text('Add to Favorites'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: () {
                                // TODO: Play audio
                              },
                              icon: const Icon(Icons.play_arrow),
                              label: const Text('Play Audio'),
                            ),
                          ),
                        ],
                      ),
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