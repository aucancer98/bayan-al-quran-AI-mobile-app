import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _fadeController;
  
  late Animation<double> _logoScale;
  late Animation<double> _logoRotation;
  late Animation<double> _textSlide;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // Logo animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    // Text animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    // Fade animation controller
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Logo animations
    _logoScale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _logoRotation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeInOut,
    ));

    // Text animation
    _textSlide = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutCubic,
    ));

    // Fade animation
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    _startAnimations();
  }

  void _startAnimations() async {
    // Start logo animation
    await _logoController.forward();
    
    // Start text animation
    await _textController.forward();
    
    // Start fade animation
    await _fadeController.forward();
    
    // Wait a bit then navigate to home
    await Future.delayed(const Duration(milliseconds: 1500));
    
    if (mounted) {
      context.go('/');
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primary,
              colorScheme.primary.withOpacity(0.8),
              colorScheme.secondary.withOpacity(0.6),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Animation
              AnimatedBuilder(
                animation: _logoController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _logoScale.value,
                    child: Transform.rotate(
                      angle: _logoRotation.value * 0.1,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorScheme.onPrimary.withOpacity(0.1),
                          border: Border.all(
                            color: colorScheme.onPrimary.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.menu_book_rounded,
                          size: 60,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 40),
              
              // App Name Animation
              AnimatedBuilder(
                animation: _textController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _textSlide.value),
                    child: Column(
                      children: [
                        Text(
                          'Bayan al Quran',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Clarity of the Quran',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onPrimary.withOpacity(0.8),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 60),
              
              // Loading Animation
              AnimatedBuilder(
                animation: _fadeController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              colorScheme.onPrimary.withOpacity(0.7),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Loading...',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onPrimary.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
