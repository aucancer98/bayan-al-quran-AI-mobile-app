import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'constants/app_theme.dart';
import 'constants/api_config.dart';
import 'utils/app_router.dart';
import 'services/service_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize API configuration
  await APIConfig.initialize();
  
  // Initialize services
  await ServiceManager().initialize();
  
  runApp(const BayanAlQuranApp());
}

class BayanAlQuranApp extends StatelessWidget {
  const BayanAlQuranApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Bayan al Quran',
      debugShowCheckedModeBanner: false,
      
      // Material 3 themes
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      
      // Localization
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'), // English
        Locale('ar', 'SA'), // Arabic
      ],
      
      // Router configuration
      routerConfig: AppRouter.router,
    );
  }
}
