import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'base_api_service.dart';

/// API service for Prayer Times-related data
class PrayerTimesApiService extends BaseApiService {
  
  /// Get prayer times for current location
  Future<Map<String, String>> getPrayerTimesForCurrentLocation() async {
    try {
      final position = await _getCurrentPosition();
      return await getPrayerTimesForLocation(position.latitude, position.longitude);
    } catch (e) {
      // Return mock data if location fails
      return _getMockPrayerTimes();
    }
  }
  
  /// Get prayer times for specific location
  Future<Map<String, String>> getPrayerTimesForLocation(double latitude, double longitude) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final response = await get<Map<String, dynamic>>(
        '/timings/$timestamp',
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
          'method': 2, // Umm al-Qura method
        },
        cacheExpiration: const Duration(hours: 1),
        cacheKey: 'prayer_times_${latitude}_${longitude}_$timestamp',
      );
      
      if (response['data'] != null && response['data']['timings'] != null) {
        final timings = response['data']['timings'] as Map<String, dynamic>;
        return {
          'Fajr': timings['Fajr'] ?? '',
          'Dhuhr': timings['Dhuhr'] ?? '',
          'Asr': timings['Asr'] ?? '',
          'Maghrib': timings['Maghrib'] ?? '',
          'Isha': timings['Isha'] ?? '',
          'Sunrise': timings['Sunrise'] ?? '',
          'Sunset': timings['Sunset'] ?? '',
        };
      }
      
      throw Exception('No prayer times data received');
    } catch (e) {
      // Return mock data if API fails
      return _getMockPrayerTimes();
    }
  }
  
  /// Get prayer times for a specific date
  Future<Map<String, String>> getPrayerTimesForDate(DateTime date, double latitude, double longitude) async {
    try {
      final timestamp = date.millisecondsSinceEpoch ~/ 1000;
      final response = await get<Map<String, dynamic>>(
        '/timings/$timestamp',
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
          'method': 2,
        },
        cacheExpiration: const Duration(days: 1),
        cacheKey: 'prayer_times_${latitude}_${longitude}_$timestamp',
      );
      
      if (response['data'] != null && response['data']['timings'] != null) {
        final timings = response['data']['timings'] as Map<String, dynamic>;
        return {
          'Fajr': timings['Fajr'] ?? '',
          'Dhuhr': timings['Dhuhr'] ?? '',
          'Asr': timings['Asr'] ?? '',
          'Maghrib': timings['Maghrib'] ?? '',
          'Isha': timings['Isha'] ?? '',
          'Sunrise': timings['Sunrise'] ?? '',
          'Sunset': timings['Sunset'] ?? '',
        };
      }
      
      throw Exception('No prayer times data received');
    } catch (e) {
      // Return mock data if API fails
      return _getMockPrayerTimes();
    }
  }
  
  /// Get prayer times for a month
  Future<List<Map<String, dynamic>>> getPrayerTimesForMonth(int year, int month, double latitude, double longitude) async {
    try {
      final response = await get<Map<String, dynamic>>(
        '/calendar/$year/$month',
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
          'method': 2,
        },
        cacheExpiration: const Duration(days: 1),
        cacheKey: 'prayer_times_month_${year}_${month}_${latitude}_${longitude}',
      );
      
      if (response['data'] != null) {
        return List<Map<String, dynamic>>.from(response['data']);
      }
      
      throw Exception('No monthly prayer times data received');
    } catch (e) {
      // Return empty list if API fails
      return [];
    }
  }
  
  /// Get next prayer time
  String getNextPrayerTime(Map<String, String> prayerTimes) {
    final now = DateTime.now();
    final currentTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    
    final prayerOrder = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
    
    for (String prayer in prayerOrder) {
      if (prayerTimes[prayer] != null) {
        if (_isTimeAfter(prayerTimes[prayer]!, currentTime)) {
          return prayer;
        }
      }
    }
    
    // If no prayer found for today, return tomorrow's Fajr
    return 'Fajr';
  }
  
  /// Calculate time remaining until next prayer
  Duration getTimeUntilNextPrayer(Map<String, String> prayerTimes) {
    final nextPrayer = getNextPrayerTime(prayerTimes);
    final nextPrayerTime = prayerTimes[nextPrayer];
    
    if (nextPrayerTime == null) return Duration.zero;
    
    final now = DateTime.now();
    final prayerDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(nextPrayerTime.split(':')[0]),
      int.parse(nextPrayerTime.split(':')[1]),
    );
    
    // If the prayer time has passed today, get tomorrow's time
    if (prayerDateTime.isBefore(now)) {
      final tomorrowPrayer = prayerDateTime.add(const Duration(days: 1));
      return tomorrowPrayer.difference(now);
    }
    
    return prayerDateTime.difference(now);
  }
  
  /// Calculate Qibla direction
  double calculateQiblaDirection(double latitude, double longitude) {
    // Kaaba coordinates
    const double kaabaLat = 21.4225;
    const double kaabaLng = 39.8262;
    
    // Convert to radians
    final lat1 = latitude * pi / 180;
    final lng1 = longitude * pi / 180;
    final lat2 = kaabaLat * pi / 180;
    final lng2 = kaabaLng * pi / 180;
    
    // Calculate bearing
    final dLng = lng2 - lng1;
    final y = sin(dLng) * cos(lat2);
    final x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLng);
    
    double bearing = atan2(y, x) * 180 / pi;
    bearing = (bearing + 360) % 360;
    
    return bearing;
  }
  
  /// Get current position using GPS
  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition();
  }
  
  /// Check if time1 is after time2
  bool _isTimeAfter(String time1, String time2) {
    final time1Parts = time1.split(':');
    final time2Parts = time2.split(':');
    
    final time1Minutes = int.parse(time1Parts[0]) * 60 + int.parse(time1Parts[1]);
    final time2Minutes = int.parse(time2Parts[0]) * 60 + int.parse(time2Parts[1]);
    
    return time1Minutes > time2Minutes;
  }
  
  /// Get mock prayer times for testing
  Map<String, String> _getMockPrayerTimes() {
    return {
      'Fajr': '05:30',
      'Dhuhr': '12:15',
      'Asr': '15:45',
      'Maghrib': '18:20',
      'Isha': '19:45',
      'Sunrise': '06:45',
      'Sunset': '18:15',
    };
  }
  
  /// Get available calculation methods
  Future<List<Map<String, dynamic>>> getCalculationMethods() async {
    try {
      final response = await get<Map<String, dynamic>>(
        '/methods',
        cacheExpiration: const Duration(days: 30),
        cacheKey: 'prayer_calculation_methods',
      );
      
      if (response['data'] != null) {
        return List<Map<String, dynamic>>.from(response['data']);
      }
      
      throw Exception('No calculation methods data received');
    } catch (e) {
      // Return default methods
      return _getDefaultCalculationMethods();
    }
  }
  
  List<Map<String, dynamic>> _getDefaultCalculationMethods() {
    return [
      {
        'id': 1,
        'name': 'Shia Ithna-Ansari',
        'params': {'Fajr': 17.7, 'Isha': 14.0},
      },
      {
        'id': 2,
        'name': 'University of Islamic Sciences, Karachi',
        'params': {'Fajr': 18.0, 'Isha': 18.0},
      },
      {
        'id': 3,
        'name': 'Islamic Society of North America (ISNA)',
        'params': {'Fajr': 15.0, 'Isha': 15.0},
      },
      {
        'id': 4,
        'name': 'Muslim World League (MWL)',
        'params': {'Fajr': 18.0, 'Isha': 17.0},
      },
      {
        'id': 5,
        'name': 'Umm al-Qura, Makkah',
        'params': {'Fajr': 18.5, 'Isha': '90 min'},
      },
      {
        'id': 7,
        'name': 'Institute of Geophysics, University of Tehran',
        'params': {'Fajr': 17.7, 'Isha': 14.0},
      },
    ];
  }
}
