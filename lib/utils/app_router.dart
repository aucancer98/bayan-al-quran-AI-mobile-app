import 'package:go_router/go_router.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/quran/surah_list_screen.dart';
import '../screens/quran/ayah_view_screen.dart';
import '../screens/quran/quran_search_screen.dart';
import '../screens/prayer/prayer_times_screen.dart';
import '../screens/prayer/qibla_screen.dart';
import '../screens/hadith/hadith_screen.dart';
import '../screens/hadith/hadith_book_selection_screen.dart';
import '../screens/hadith/hadith_titles_screen.dart';
import '../screens/supplications/supplications_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/settings/ai_settings_screen.dart';
import '../screens/calendar/islamic_calendar_screen.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/quran',
        name: 'quran',
        builder: (context, state) => const SurahListScreen(),
        routes: [
          GoRoute(
            path: 'search',
            name: 'quran-search',
            builder: (context, state) => const QuranSearchScreen(),
          ),
          GoRoute(
            path: 'surah/:surahNumber',
            name: 'surah',
            builder: (context, state) {
              final surahNumber = int.parse(state.pathParameters['surahNumber']!);
              return AyahViewScreen(surahNumber: surahNumber);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/prayer',
        name: 'prayer',
        builder: (context, state) => const PrayerTimesScreen(),
        routes: [
          GoRoute(
            path: 'qibla',
            name: 'qibla',
            builder: (context, state) => const QiblaScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/hadith',
        name: 'hadith',
        builder: (context, state) => const HadithScreen(),
        routes: [
          GoRoute(
            path: 'books',
            name: 'hadith-books',
            builder: (context, state) => const HadithBookSelectionScreen(),
            routes: [
              GoRoute(
                path: ':collectionName',
                name: 'hadith-titles',
                builder: (context, state) {
                  final collectionName = state.pathParameters['collectionName']!;
                  return HadithTitlesScreen(collectionName: collectionName);
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/supplications',
        name: 'supplications',
        builder: (context, state) => const SupplicationsScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
        routes: [
          GoRoute(
            path: 'ai',
            name: 'ai-settings',
            builder: (context, state) => const AISettingsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/calendar',
        name: 'calendar',
        builder: (context, state) => const IslamicCalendarScreen(),
      ),
    ],
  );

  static GoRouter get router => _router;
}
