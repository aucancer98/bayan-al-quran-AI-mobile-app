import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import '../../services/prayer_times_service.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> with TickerProviderStateMixin {
  double? _qiblaDirection;
  double? _currentLatitude;
  double? _currentLongitude;
  bool _isLoading = true;
  String _errorMessage = '';
  late AnimationController _compassController;
  late Animation<double> _compassAnimation;

  @override
  void initState() {
    super.initState();
    _compassController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _compassAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _compassController,
      curve: Curves.easeInOut,
    ));
    _getLocationAndQibla();
  }

  @override
  void dispose() {
    _compassController.dispose();
    super.dispose();
  }

  Future<void> _getLocationAndQibla() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      // Get current position
      Position position = await Geolocator.getCurrentPosition();
      
      setState(() {
        _currentLatitude = position.latitude;
        _currentLongitude = position.longitude;
      });

      // Calculate Qibla direction
      final qiblaDirection = PrayerTimesService.calculateQiblaDirection(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _qiblaDirection = qiblaDirection;
        _isLoading = false;
      });

      // Start compass animation
      _compassController.forward();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Unable to get location: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Qibla Direction'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/prayer'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _getLocationAndQibla,
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
                    'Getting your location...',
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
                        Icons.location_off,
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
                        onPressed: _getLocationAndQibla,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Try Again'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Qibla Compass
                      _buildQiblaCompass(theme, colorScheme),
                      
                      const SizedBox(height: 32),
                      
                      // Location Info
                      _buildLocationInfo(theme, colorScheme),
                      
                      const SizedBox(height: 24),
                      
                      // Instructions
                      _buildInstructions(theme, colorScheme),
                    ],
                  ),
                ),
    );
  }

  Widget _buildQiblaCompass(ThemeData theme, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              'Qibla Direction',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 200,
              height: 200,
              child: AnimatedBuilder(
                animation: _compassAnimation,
                builder: (context, child) {
                  return CustomPaint(
                    painter: QiblaCompassPainter(
                      qiblaDirection: _qiblaDirection ?? 0,
                      animationValue: _compassAnimation.value,
                      colorScheme: colorScheme,
                    ),
                    size: const Size(200, 200),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${_qiblaDirection?.toStringAsFixed(1) ?? '0.0'}°',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _getDirectionText(_qiblaDirection ?? 0),
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationInfo(ThemeData theme, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Your Location',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_currentLatitude != null && _currentLongitude != null) ...[
              _buildLocationRow('Latitude', '${_currentLatitude!.toStringAsFixed(4)}°', theme, colorScheme),
              _buildLocationRow('Longitude', '${_currentLongitude!.toStringAsFixed(4)}°', theme, colorScheme),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLocationRow(String label, String value, ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
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

  Widget _buildInstructions(ThemeData theme, ColorScheme colorScheme) {
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
                  color: colorScheme.secondary,
                ),
                const SizedBox(width: 8),
                Text(
                  'How to Use',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInstructionItem(
              '1. Hold your device flat',
              'Place your phone horizontally for accurate compass reading',
              theme,
              colorScheme,
            ),
            _buildInstructionItem(
              '2. Face the red arrow',
              'The red arrow points towards the Kaaba in Mecca',
              theme,
              colorScheme,
            ),
            _buildInstructionItem(
              '3. Calibrate if needed',
              'Move your device in a figure-8 motion to calibrate the compass',
              theme,
              colorScheme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionItem(String title, String description, ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  String _getDirectionText(double degrees) {
    if (degrees >= 337.5 || degrees < 22.5) return 'North';
    if (degrees >= 22.5 && degrees < 67.5) return 'Northeast';
    if (degrees >= 67.5 && degrees < 112.5) return 'East';
    if (degrees >= 112.5 && degrees < 157.5) return 'Southeast';
    if (degrees >= 157.5 && degrees < 202.5) return 'South';
    if (degrees >= 202.5 && degrees < 247.5) return 'Southwest';
    if (degrees >= 247.5 && degrees < 292.5) return 'West';
    if (degrees >= 292.5 && degrees < 337.5) return 'Northwest';
    return 'Unknown';
  }
}

class QiblaCompassPainter extends CustomPainter {
  final double qiblaDirection;
  final double animationValue;
  final ColorScheme colorScheme;

  QiblaCompassPainter({
    required this.qiblaDirection,
    required this.animationValue,
    required this.colorScheme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Draw compass circle
    final circlePaint = Paint()
      ..color = colorScheme.surfaceVariant
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = colorScheme.outline
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, radius, circlePaint);
    canvas.drawCircle(center, radius, borderPaint);

    // Draw compass directions
    _drawCompassDirections(canvas, center, radius);

    // Draw Qibla arrow
    _drawQiblaArrow(canvas, center, radius);
  }

  void _drawCompassDirections(Canvas canvas, Offset center, double radius) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final directions = ['N', 'E', 'S', 'W'];
    final angles = [0, 90, 180, 270];

    for (int i = 0; i < directions.length; i++) {
      final angle = angles[i] * 3.14159 / 180;
      final x = center.dx + (radius - 20) * math.sin(angle);
      final y = center.dy - (radius - 20) * math.cos(angle);

      textPainter.text = TextSpan(
        text: directions[i],
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: colorScheme.primary,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, y - textPainter.height / 2),
      );
    }
  }

  void _drawQiblaArrow(Canvas canvas, Offset center, double radius) {
    final arrowPaint = Paint()
      ..color = colorScheme.error
      ..style = PaintingStyle.fill;

    final arrowAngle = (qiblaDirection * 3.14159 / 180) * animationValue;
    final arrowLength = radius - 30;

    // Draw arrow line
    final arrowEnd = Offset(
      center.dx + arrowLength * math.sin(arrowAngle),
      center.dy - arrowLength * math.cos(arrowAngle),
    );

    final linePaint = Paint()
      ..color = colorScheme.error
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawLine(center, arrowEnd, linePaint);

    // Draw arrow head
    final arrowHeadSize = 15.0;
    final path = Path();
    path.moveTo(arrowEnd.dx, arrowEnd.dy);
    path.lineTo(
      arrowEnd.dx - arrowHeadSize * math.sin(arrowAngle - 0.5),
      arrowEnd.dy + arrowHeadSize * math.cos(arrowAngle - 0.5),
    );
    path.lineTo(
      arrowEnd.dx - arrowHeadSize * math.sin(arrowAngle + 0.5),
      arrowEnd.dy + arrowHeadSize * math.cos(arrowAngle + 0.5),
    );
    path.close();

    canvas.drawPath(path, arrowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
