// AI Settings Screen for configuring DeepSeek R1 via OpenRouter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/api_config.dart';

class AISettingsScreen extends StatefulWidget {
  const AISettingsScreen({super.key});

  @override
  State<AISettingsScreen> createState() => _AISettingsScreenState();
}

class _AISettingsScreenState extends State<AISettingsScreen> {
  final _openrouterController = TextEditingController();
  
  bool _isLoading = false;
  Map<String, dynamic> _apiStatus = {};

  @override
  void initState() {
    super.initState();
    _loadCurrentKeys();
    _loadAPIStatus();
  }

  @override
  void dispose() {
    _openrouterController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentKeys() async {
    await APIConfig.initialize();
    setState(() {
      _openrouterController.text = APIConfig.openrouterApiKey ?? '';
    });
  }

  Future<void> _loadAPIStatus() async {
    setState(() {
      _apiStatus = APIConfig.status;
    });
  }

  Future<void> _saveKeys() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Save OpenRouter API key
      if (_openrouterController.text.isNotEmpty) {
        if (APIConfig.isValidOpenRouterKey(_openrouterController.text)) {
          final success = await APIConfig.saveOpenRouterKey(_openrouterController.text);
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('OpenRouter API key saved successfully'),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Invalid OpenRouter API key format'),
                backgroundColor: Colors.red,
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid OpenRouter API key format. Must start with "sk-or-" and be at least 50 characters'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        // Remove the key if empty
        await APIConfig.removeOpenRouterKey();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OpenRouter API key removed'),
            backgroundColor: Colors.orange,
          ),
        );
      }

      await _loadAPIStatus();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving API keys: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Settings'),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // DeepSeek R1 Configuration Card
            _buildDeepSeekR1Card(theme, colorScheme),
            
            const SizedBox(height: 24),
            
            // API Status Card
            _buildAPIStatusCard(theme, colorScheme),
            
            const SizedBox(height: 24),
            
            // Help Card
            _buildHelpCard(theme, colorScheme),
            
            const SizedBox(height: 32),
            
            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveKeys,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Save Configuration',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeepSeekR1Card(ThemeData theme, ColorScheme colorScheme) {
    final isConfigured = APIConfig.hasDeepSeekR1;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.psychology_alt,
                  color: isConfigured ? Colors.green : colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'DeepSeek R1 (Primary AI)',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isConfigured ? Colors.green : colorScheme.primary,
                  ),
                ),
                const Spacer(),
                if (isConfigured)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'CONFIGURED',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Advanced reasoning AI with excellent Islamic knowledge and Arabic understanding. This is the primary AI model for all features in the app.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _openrouterController,
              decoration: InputDecoration(
                labelText: 'OpenRouter API Key',
                hintText: 'sk-or-...',
                prefixIcon: const Icon(Icons.key),
                suffixIcon: _openrouterController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: _openrouterController.text));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('API key copied to clipboard')),
                        );
                      },
                    )
                  : null,
                border: const OutlineInputBorder(),
                helperText: 'Get your API key from openrouter.ai',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colorScheme.primary.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.star,
                    color: colorScheme.primary,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'DeepSeek R1 is the only AI model used in this app. It provides comprehensive Islamic analysis for all features.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAPIStatusCard(ThemeData theme, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
                  'AI Service Status',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildStatusItem(
              'DeepSeek R1 (OpenRouter)',
              APIConfig.hasDeepSeekR1,
              theme,
              colorScheme,
            ),
            const SizedBox(height: 8),
            Text(
              'Primary Service: ${APIConfig.primaryService}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Available Services: ${APIConfig.availableServices.join(", ")}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(String service, bool isAvailable, ThemeData theme, ColorScheme colorScheme) {
    return Row(
      children: [
        Icon(
          isAvailable ? Icons.check_circle : Icons.cancel,
          color: isAvailable ? Colors.green : Colors.red,
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          service,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isAvailable ? Colors.green : Colors.red,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildHelpCard(ThemeData theme, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.help_outline,
                  color: colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'How to Get Started',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildHelpStep(
              '1',
              'Visit openrouter.ai',
              'Create an account and get your API key',
              theme,
              colorScheme,
            ),
            const SizedBox(height: 12),
            _buildHelpStep(
              '2',
              'Copy your API key',
              'It should start with "sk-or-" and be at least 50 characters long',
              theme,
              colorScheme,
            ),
            const SizedBox(height: 12),
            _buildHelpStep(
              '3',
              'Paste and save',
              'Enter your API key above and tap "Save Configuration"',
              theme,
              colorScheme,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Once configured, DeepSeek R1 will provide AI analysis for Quranic words, Hadith search, and other Islamic content throughout the app.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpStep(String number, String title, String description, ThemeData theme, ColorScheme colorScheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}