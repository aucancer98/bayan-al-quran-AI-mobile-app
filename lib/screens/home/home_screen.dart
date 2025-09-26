import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/mock_data_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bayan al Quran'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              context.go('/settings');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome section
              Text(
                'Assalamu Alaikum',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your Islamic companion for learning and worship',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              
              // Prayer times widget
              _buildPrayerTimesCard(context),
              const SizedBox(height: 16),
              
              // Main modules grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: [
                    _buildModuleCard(
                      context: context,
                      title: 'Quran',
                      subtitle: 'Word-by-word analysis',
                      icon: Icons.menu_book_outlined,
                      color: colorScheme.primary,
                      onTap: () {
                        context.go('/quran');
                      },
                    ),
                    _buildModuleCard(
                      context: context,
                      title: 'Prayer Times',
                      subtitle: 'Daily prayers',
                      icon: Icons.access_time_outlined,
                      color: colorScheme.secondary,
                      onTap: () {
                        context.go('/prayer');
                      },
                    ),
                    _buildModuleCard(
                      context: context,
                      title: 'Ahadith',
                      subtitle: 'Authentic traditions',
                      icon: Icons.article_outlined,
                      color: colorScheme.tertiary,
                      onTap: () {
                        context.go('/hadith');
                      },
                    ),
                    _buildModuleCard(
                      context: context,
                      title: 'Supplications',
                      subtitle: 'Daily duas',
                      icon: Icons.favorite_outline,
                      color: colorScheme.error,
                      onTap: () {
                        context.go('/supplications');
                      },
                    ),
                    _buildModuleCard(
                      context: context,
                      title: 'Qibla',
                      subtitle: 'Prayer direction',
                      icon: Icons.explore_outlined,
                      color: colorScheme.primaryContainer,
                      onTap: () {
                        context.go('/prayer/qibla');
                      },
                    ),
                    _buildModuleCard(
                      context: context,
                      title: 'Islamic Calendar',
                      subtitle: 'Hijri dates',
                      icon: Icons.calendar_month_outlined,
                      color: colorScheme.secondaryContainer,
                      onTap: () {
                        context.go('/calendar');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrayerTimesCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final prayerTimes = MockDataService.getMockPrayerTimes();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.access_time_outlined,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Prayer Times',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  'Today',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPrayerTime('Fajr', prayerTimes['Fajr']!, colorScheme),
                _buildPrayerTime('Dhuhr', prayerTimes['Dhuhr']!, colorScheme),
                _buildPrayerTime('Asr', prayerTimes['Asr']!, colorScheme),
                _buildPrayerTime('Maghrib', prayerTimes['Maghrib']!, colorScheme),
                _buildPrayerTime('Isha', prayerTimes['Isha']!, colorScheme),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerTime(String name, String time, ColorScheme colorScheme) {
    return Column(
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildModuleCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: color,
                ),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
