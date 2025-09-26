class AppConstants {
  // App Information
  static const String appName = 'Bayan al Quran';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'A comprehensive Islamic companion app';
  
  // API Endpoints
  static const String quranApiBaseUrl = 'https://api.alquran.cloud/v1';
  static const String prayerTimesApiBaseUrl = 'https://api.aladhan.com/v1';
  
  // Database
  static const String databaseName = 'bayan_al_quran.db';
  static const int databaseVersion = 1;
  
  // Fonts
  static const String arabicFontFamily = 'Amiri';
  static const String englishFontFamily = 'Roboto';
  
  // Prayer Times
  static const List<String> prayerNames = [
    'Fajr',
    'Dhuhr', 
    'Asr',
    'Maghrib',
    'Isha',
  ];
  
  // Quran
  static const int totalSurahs = 114;
  static const int totalAyahs = 6236;
  
  // Default Settings
  static const String defaultTranslation = 'Sahih International';
  static const String defaultLanguage = 'en';
  static const bool defaultRTL = false;
  static const double defaultFontSize = 16.0;
  
  // Islamic Colors
  static const int primaryGreen = 0xFF2E7D32;
  static const int secondaryBlue = 0xFF1976D2;
  static const int accentGold = 0xFFFFB300;
}
