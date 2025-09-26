import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/prayer_times_service.dart';

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  Map<String, String>? _prayerTimes;
  bool _isLoading = true;
  String _errorMessage = '';
  String _nextPrayer = '';
  Duration _timeUntilNext = Duration.zero;

  @override
  void initState() {
    super.initState();
    _loadPrayerTimes();
    _startTimer();
  }

  void _startTimer() {
    // Update countdown every minute
    Future.delayed(const Duration(minutes: 1), () {
      if (mounted) {
        setState(() {
          if (_prayerTimes != null) {
            _nextPrayer = PrayerTimesService.getNextPrayerTime(_prayerTimes!);
            _timeUntilNext = PrayerTimesService.getTimeUntilNextPrayer(_prayerTimes!);
          }
        });
        _startTimer();
      }
    });
  }

  Future<void> _loadPrayerTimes() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final prayerTimes = await PrayerTimesService.getPrayerTimesForCurrentLocation();
      
      setState(() {
        _prayerTimes = prayerTimes;
        _nextPrayer = PrayerTimesService.getNextPrayerTime(prayerTimes);
        _timeUntilNext = PrayerTimesService.getTimeUntilNextPrayer(prayerTimes);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load prayer times: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer Times'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPrayerTimes,
          ),
          IconButton(
            icon: const Icon(Icons.explore),
            onPressed: () => context.go('/prayer/qibla'),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Loading prayer times...',
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            )
          : _errorMessage.isNotEmpty
              ? Center(
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
                        _errorMessage,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: _loadPrayerTimes,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Try Again'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Next prayer card
                      _buildNextPrayerCard(theme, colorScheme),
                      
                      const SizedBox(height: 16),
                      
                      // Prayer times list
                      _buildPrayerTimesList(theme, colorScheme),
                      
                      const SizedBox(height: 16),
                      
                      // Quick actions
                      _buildQuickActions(theme, colorScheme),
                    ],
                  ),
                ),
    );
  }

  Widget _buildNextPrayerCard(ThemeData theme, ColorScheme colorScheme) {
    final nextPrayerTime = _prayerTimes?[_nextPrayer] ?? '';
    final hours = _timeUntilNext.inHours;
    final minutes = _timeUntilNext.inMinutes % 60;

    return Card(
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              colorScheme.primary,
              colorScheme.primary.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Icon(
                Icons.access_time,
                size: 32,
                color: colorScheme.onPrimary,
              ),
              const SizedBox(height: 8),
              Text(
                'Next Prayer',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _nextPrayer,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                nextPrayerTime,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colorScheme.onPrimary.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'in ${hours}h ${minutes}m',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onPrimary.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrayerTimesList(ThemeData theme, ColorScheme colorScheme) {
    final prayerOrder = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
    final prayerIcons = {
      'Fajr': Icons.wb_sunny_outlined,
      'Dhuhr': Icons.wb_sunny,
      'Asr': Icons.wb_twilight,
      'Maghrib': Icons.wb_sunny_outlined,
      'Isha': Icons.nights_stay_outlined,
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Today\'s Prayer Times',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...prayerOrder.map((prayer) {
              final time = _prayerTimes?[prayer] ?? '';
              final isNext = prayer == _nextPrayer;
              return _buildPrayerTimeRow(
                prayer,
                time,
                prayerIcons[prayer]!,
                theme,
                colorScheme,
                isNext,
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerTimeRow(
    String prayer,
    String time,
    IconData icon,
    ThemeData theme,
    ColorScheme colorScheme,
    bool isNext,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: isNext ? colorScheme.primaryContainer : null,
        borderRadius: BorderRadius.circular(8),
        border: isNext ? Border.all(color: colorScheme.primary, width: 1) : null,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isNext ? colorScheme.primary : colorScheme.onSurfaceVariant,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              prayer,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: isNext ? FontWeight.w600 : FontWeight.w500,
                color: isNext ? colorScheme.primary : null,
              ),
            ),
          ),
          Text(
            time,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: isNext ? colorScheme.primary : colorScheme.primary,
            ),
          ),
          if (isNext) ...[
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward,
              size: 16,
              color: colorScheme.primary,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickActions(ThemeData theme, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => context.go('/prayer/qibla'),
                    icon: const Icon(Icons.explore),
                    label: const Text('Qibla'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Open location settings
                    },
                    icon: const Icon(Icons.location_on),
                    label: const Text('Location'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}