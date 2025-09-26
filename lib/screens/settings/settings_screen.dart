import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedTranslation = 'Sahih International';
  double _fontSize = 16.0;
  String _selectedLanguage = 'English';

  final List<String> _translations = [
    'Sahih International',
    'Yusuf Ali',
    'Muhammad ﷺ Muhsin Khan',
    'Pickthall',
    'Shakir',
  ];

  final List<String> _languages = [
    'English',
    'Arabic',
    'Urdu',
    'French',
    'Spanish',
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      _darkModeEnabled = prefs.getBool('dark_mode_enabled') ?? false;
      _selectedTranslation = prefs.getString('selected_translation') ?? 'Sahih International';
      _fontSize = prefs.getDouble('font_size') ?? 16.0;
      _selectedLanguage = prefs.getString('selected_language') ?? 'English';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', _notificationsEnabled);
    await prefs.setBool('dark_mode_enabled', _darkModeEnabled);
    await prefs.setString('selected_translation', _selectedTranslation);
    await prefs.setDouble('font_size', _fontSize);
    await prefs.setString('selected_language', _selectedLanguage);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveSettings,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Info Section
            _buildSectionHeader('App Information', Icons.info_outline, theme, colorScheme),
            _buildAppInfoCard(theme, colorScheme),
            
            const SizedBox(height: 24),
            
            // Quran Settings Section
            _buildSectionHeader('Quran Settings', Icons.menu_book, theme, colorScheme),
            _buildQuranSettingsCard(theme, colorScheme),
            
            const SizedBox(height: 24),
            
            // Prayer Settings Section
            _buildSectionHeader('Prayer Settings', Icons.access_time, theme, colorScheme),
            _buildPrayerSettingsCard(theme, colorScheme),
            
            const SizedBox(height: 24),
            
            // Display Settings Section
            _buildSectionHeader('Display Settings', Icons.palette, theme, colorScheme),
            _buildDisplaySettingsCard(theme, colorScheme),
            
            const SizedBox(height: 24),
            
            // AI Settings Section
            _buildSectionHeader('AI Features', Icons.psychology, theme, colorScheme),
            _buildAISettingsCard(theme, colorScheme),
            
            const SizedBox(height: 24),
            
            // About Section
            _buildSectionHeader('About', Icons.help_outline, theme, colorScheme),
            _buildAboutCard(theme, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppInfoCard(ThemeData theme, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoRow('App Name', 'Bayan al Quran', theme, colorScheme),
            _buildInfoRow('Version', '1.0.0', theme, colorScheme),
            _buildInfoRow('Build', '2024.1', theme, colorScheme),
            _buildInfoRow('Developer', 'Bayan al Quran Team', theme, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildQuranSettingsCard(ThemeData theme, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDropdownSetting(
              'Translation',
              _selectedTranslation,
              _translations,
              (value) => setState(() => _selectedTranslation = value!),
              theme,
              colorScheme,
            ),
            const Divider(),
            _buildSliderSetting(
              'Font Size',
              _fontSize,
              12.0,
              24.0,
              (value) => setState(() => _fontSize = value),
              theme,
              colorScheme,
            ),
            const Divider(),
            _buildSwitchSetting(
              'Show Word Meanings',
              true,
              (value) {
                // TODO: Implement word meanings toggle
              },
              theme,
              colorScheme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerSettingsCard(ThemeData theme, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSwitchSetting(
              'Prayer Notifications',
              _notificationsEnabled,
              (value) => setState(() => _notificationsEnabled = value),
              theme,
              colorScheme,
            ),
            const Divider(),
            _buildDropdownSetting(
              'Calculation Method',
              'Umm al-Qura',
              ['Umm al-Qura', 'Muslim World League', 'Islamic Society of North America'],
              (value) {
                // TODO: Implement calculation method
              },
              theme,
              colorScheme,
            ),
            const Divider(),
            _buildDropdownSetting(
              'Language',
              _selectedLanguage,
              _languages,
              (value) => setState(() => _selectedLanguage = value!),
              theme,
              colorScheme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisplaySettingsCard(ThemeData theme, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSwitchSetting(
              'Dark Mode',
              _darkModeEnabled,
              (value) => setState(() => _darkModeEnabled = value),
              theme,
              colorScheme,
            ),
            const Divider(),
            _buildSwitchSetting(
              'Dynamic Colors',
              false,
              (value) {
                // TODO: Implement dynamic colors
              },
              theme,
              colorScheme,
            ),
            const Divider(),
            _buildSwitchSetting(
              'RTL Support',
              true,
              (value) {
                // TODO: Implement RTL toggle
              },
              theme,
              colorScheme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAISettingsCard(ThemeData theme, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.psychology, color: colorScheme.primary),
              title: const Text('AI Configuration'),
              subtitle: const Text('Configure AI services for comprehensive analysis'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => context.go('/settings/ai'),
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.auto_awesome, color: colorScheme.primary),
              title: const Text('AI Features'),
              subtitle: const Text('Word analysis, thematic connections, Hadith integration'),
              trailing: const Icon(Icons.info_outline, size: 16),
              onTap: () {
                // TODO: Show AI features info
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutCard(ThemeData theme, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.privacy_tip_outlined, color: colorScheme.primary),
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: Open privacy policy
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.description_outlined, color: colorScheme.primary),
              title: const Text('Terms of Service'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: Open terms of service
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.help_outline, color: colorScheme.primary),
              title: const Text('Help & Support'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: Open help
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.star_outline, color: colorScheme.primary),
              title: const Text('Rate App'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: Open app store rating
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchSetting(
    String title,
    bool value,
    ValueChanged<bool> onChanged,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return SwitchListTile(
      title: Text(
        title,
        style: theme.textTheme.bodyLarge,
      ),
      value: value,
      onChanged: onChanged,
      activeColor: colorScheme.primary,
    );
  }

  Widget _buildDropdownSetting(
    String title,
    String value,
    List<String> options,
    ValueChanged<String?> onChanged,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return ListTile(
      title: Text(
        title,
        style: theme.textTheme.bodyLarge,
      ),
      trailing: DropdownButton<String>(
        value: value,
        onChanged: onChanged,
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
        underline: Container(),
      ),
    );
  }

  Widget _buildSliderSetting(
    String title,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyLarge,
              ),
              Text(
                '${value.toInt()}',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          onChanged: onChanged,
          activeColor: colorScheme.primary,
        ),
      ],
    );
  }
}