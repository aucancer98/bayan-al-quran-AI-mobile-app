import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/calendar_service.dart';
import '../../models/calendar_models.dart';
import '../../widgets/arabic_text.dart';

class IslamicCalendarScreen extends StatefulWidget {
  const IslamicCalendarScreen({super.key});

  @override
  State<IslamicCalendarScreen> createState() => _IslamicCalendarScreenState();
}

class _IslamicCalendarScreenState extends State<IslamicCalendarScreen> {
  late DateTime _selectedDate;
  late PageController _pageController;
  int _currentIslamicMonth = 1; // Start with Muharram
  int _currentIslamicYear = 1446; // Current Islamic year
  List<IslamicEvent> _allEvents = [];
  Map<String, dynamic>? _currentMonthInfo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    // Get current Islamic date to initialize the calendar
    final currentIslamicDate = CalendarService.getCurrentIslamicDate();
    _currentIslamicMonth = currentIslamicDate.month;
    _currentIslamicYear = currentIslamicDate.year;
    _pageController = PageController(initialPage: _currentIslamicMonth - 1);
    _loadCalendarData();
  }

  Future<void> _loadCalendarData() async {
    try {
      final events = await CalendarService.getAllEventsAsync();
      final monthInfo = await CalendarService.getIslamicMonthInfo(_currentIslamicMonth);
      if (mounted) {
        setState(() {
          _allEvents = events;
          _currentMonthInfo = monthInfo;
          _isLoading = false;
        });
        // Debug: Print loaded events
        print('Loaded ${events.length} events from JSON');
        for (final event in events.take(5)) { // Show first 5 events
          print('Event: ${event.name} on ${event.date.day}/${event.date.month}/${event.date.year}');
        }
      }
    } catch (e) {
      print('Error loading events: $e');
      // Fallback to mock data
      if (mounted) {
        setState(() {
          _allEvents = CalendarService.getUpcomingEvents();
          _currentMonthInfo = null;
          _isLoading = false;
        });
        print('Using fallback events: ${_allEvents.length}');
      }
    }
  }

  Future<void> _loadMonthInfo() async {
    try {
      final monthInfo = await CalendarService.getIslamicMonthInfo(_currentIslamicMonth);
      if (mounted) {
        setState(() {
          _currentMonthInfo = monthInfo;
        });
      }
    } catch (e) {
      // Handle error silently
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Islamic Calendar'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: () {
              setState(() {
                _selectedDate = DateTime.now();
                final currentIslamicDate = CalendarService.getCurrentIslamicDate();
                _currentIslamicMonth = currentIslamicDate.month;
                _currentIslamicYear = currentIslamicDate.year;
                _pageController.animateToPage(
                  _currentIslamicMonth - 1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              });
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
          : SingleChildScrollView(
              child: Column(
                children: [
                // Current Islamic Date
                _buildCurrentIslamicDate(theme, colorScheme),
                
                // Calendar Header
                _buildCalendarHeader(theme, colorScheme),
                
                // Calendar Grid
                SizedBox(
                  height: 400, // Fixed height to show all days at once
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (month) {
                      setState(() {
                        _currentIslamicMonth = month + 1;
                        if (_currentIslamicMonth == 13) {
                          _currentIslamicYear++;
                          _currentIslamicMonth = 1;
                        } else if (_currentIslamicMonth == 0) {
                          _currentIslamicYear--;
                          _currentIslamicMonth = 12;
                        }
                      });
                      _loadMonthInfo(); // Load info for the new month
                    },
                    itemBuilder: (context, monthIndex) {
                      return _buildCalendarMonth(monthIndex + 1, theme, colorScheme);
                    },
                  ),
                ),
                
                // Selected Date Events
                if (_getEventsForSelectedDate().isNotEmpty)
                  _buildSelectedDateEvents(theme, colorScheme),
                
                // Month Information
                if (_currentMonthInfo != null)
                  _buildMonthInfo(theme, colorScheme),
                ],
              ),
            ),
    );
  }

  Widget _buildCurrentIslamicDate(ThemeData theme, ColorScheme colorScheme) {
    final islamicDate = CalendarService.getCurrentIslamicDate();
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Today\'s Islamic Date',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${islamicDate.day}',
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: ArabicText(
                      islamicDate.monthName,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Text(
                    '${islamicDate.year} AH',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onPrimary.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMonthInfo(ThemeData theme, ColorScheme colorScheme) {
    if (_currentMonthInfo == null) return const SizedBox.shrink();
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'About ${_currentMonthInfo!['name']}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _currentMonthInfo!['description'] ?? '',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          if (_currentMonthInfo!['significance'] != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.star_outline,
                  color: colorScheme.secondary,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  'Significance: ${_currentMonthInfo!['significance']}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.secondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
          if (_currentMonthInfo!['recommendedActs'] != null) ...[
            const SizedBox(height: 8),
            Text(
              'Recommended Acts:',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: (_currentMonthInfo!['recommendedActs'] as List<dynamic>)
                  .map((act) => Chip(
                        label: Text(
                          act as String,
                          style: theme.textTheme.bodySmall,
                        ),
                        backgroundColor: colorScheme.primaryContainer.withOpacity(0.3),
                        side: BorderSide.none,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCalendarHeader(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            icon: const Icon(Icons.chevron_left),
          ),
          Text(
            '${CalendarService.getMonthName(_currentIslamicMonth)} $_currentIslamicYear AH',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
          IconButton(
            onPressed: () {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarMonth(int month, ThemeData theme, ColorScheme colorScheme) {
    // For now, we'll use Gregorian calendar structure but show Islamic month names
    // This is a common approach in Islamic calendar apps
    final daysInMonth = DateTime(DateTime.now().year, month + 1, 0).day;
    final firstDayOfMonth = DateTime(DateTime.now().year, month, 1);
    final startingWeekday = firstDayOfMonth.weekday;
    
    // Get current Islamic date for highlighting
    final currentIslamicDate = CalendarService.getCurrentIslamicDate();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          // Weekday headers
          Row(
            children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                .map((day) => Expanded(
                      child: Center(
                        child: Text(
                          day,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
          
          // Calendar grid
          SizedBox(
            height: 350, // Fixed height for the calendar grid
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1,
              ),
              itemCount: 42, // 6 weeks * 7 days
              itemBuilder: (context, index) {
                final day = index - startingWeekday + 2;
                final isCurrentMonth = day > 0 && day <= daysInMonth;
                final date = isCurrentMonth ? DateTime(DateTime.now().year, month, day) : null;
                final isSelected = date != null && 
                    date.year == _selectedDate.year &&
                    date.month == _selectedDate.month &&
                    date.day == _selectedDate.day;
                final isToday = date != null && 
                    date.year == DateTime.now().year &&
                    date.month == DateTime.now().month &&
                    date.day == DateTime.now().day;
                
                // Check if this day corresponds to the current Islamic date
                final isCurrentIslamicDate = date != null && 
                    month == currentIslamicDate.month && 
                    day == currentIslamicDate.day;
                
                final hasEvents = date != null && _getEventsForDate(date).isNotEmpty;
                
                return GestureDetector(
                  onTap: isCurrentMonth ? () {
                    setState(() {
                      _selectedDate = date!;
                    });
                  } : null,
                  child: Container(
                    margin: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? colorScheme.primary
                          : isCurrentIslamicDate
                              ? colorScheme.tertiary
                              : isToday
                                  ? colorScheme.primaryContainer
                                  : hasEvents
                                      ? colorScheme.secondaryContainer.withOpacity(0.3)
                                      : null,
                      borderRadius: BorderRadius.circular(8),
                      border: isCurrentIslamicDate && !isSelected
                          ? Border.all(color: colorScheme.tertiary, width: 2)
                          : hasEvents && !isSelected && !isToday && !isCurrentIslamicDate
                              ? Border.all(color: colorScheme.secondary, width: 1)
                              : null,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isCurrentMonth ? '$day' : '',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isSelected 
                                  ? colorScheme.onPrimary
                                  : isCurrentIslamicDate
                                      ? colorScheme.onTertiary
                                      : isToday
                                          ? colorScheme.onPrimaryContainer
                                          : colorScheme.onSurface,
                              fontWeight: isToday || isSelected || isCurrentIslamicDate ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          if (isCurrentIslamicDate && isCurrentMonth)
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: colorScheme.onTertiary,
                                shape: BoxShape.circle,
                              ),
                            )
                          else if (hasEvents && isCurrentMonth)
                            Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: isSelected 
                                    ? colorScheme.onPrimary
                                    : colorScheme.secondary,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedDateEvents(ThemeData theme, ColorScheme colorScheme) {
    final events = _getEventsForSelectedDate();
    
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Events on ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  child: ListTile(
                    leading: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _getEventColor(event.importance, colorScheme),
                        shape: BoxShape.circle,
                      ),
                    ),
                    title: Text(
                      event.name,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      event.description,
                      style: theme.textTheme.bodySmall,
                    ),
                    trailing: Text(
                      event.type.toUpperCase(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () => _showEventDetail(event, theme, colorScheme),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showEventDetail(IslamicEvent event, ThemeData theme, ColorScheme colorScheme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.8,
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
                              color: _getEventColor(event.importance, colorScheme),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              event.importance.toUpperCase(),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onPrimary,
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
                              event.type.toUpperCase(),
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
                        event.name,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Date
                      Text(
                        '${event.date.day}/${event.date.month}/${event.date.year}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Description
                      Text(
                        'Description',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        event.description,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                        ),
                      ),
                      
                      if (event.traditions.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text(
                          'Traditions & Practices',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...event.traditions.map((tradition) => Padding(
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
                                  tradition,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        )),
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

  List<IslamicEvent> _getEventsForSelectedDate() {
    final events = _allEvents.where((event) => 
      event.date.year == _selectedDate.year && 
      event.date.month == _selectedDate.month && 
      event.date.day == _selectedDate.day
    ).toList();
    
    // Debug: Print information about events
    print('Selected date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}');
    print('Total events loaded: ${_allEvents.length}');
    print('Events for selected date: ${events.length}');
    if (events.isNotEmpty) {
      for (final event in events) {
        print('Event: ${event.name} on ${event.date.day}/${event.date.month}/${event.date.year}');
      }
    }
    
    return events;
  }

  List<IslamicEvent> _getEventsForDate(DateTime date) {
    return _allEvents.where((event) => 
      event.date.year == date.year && 
      event.date.month == date.month && 
      event.date.day == date.day
    ).toList();
  }

  Color _getEventColor(String importance, ColorScheme colorScheme) {
    switch (importance.toLowerCase()) {
      case 'high':
        return colorScheme.error;
      case 'medium':
        return colorScheme.primary;
      case 'low':
        return colorScheme.secondary;
      default:
        return colorScheme.surfaceVariant;
    }
  }
}

