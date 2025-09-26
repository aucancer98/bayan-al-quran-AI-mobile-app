import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'api/prayer_times_api_service.dart';

class PrayerTimesService {
  static final PrayerTimesApiService _apiService = PrayerTimesApiService();
  
  /// Get prayer times for current location
  static Future<Map<String, String>> getPrayerTimesForCurrentLocation() async {
    try {
      return await _apiService.getPrayerTimesForCurrentLocation();
    } catch (e) {
      // Return mock data if API fails
      return _getMockPrayerTimes();
    }
  }
  
  /// Get prayer times for specific location
  static Future<Map<String, String>> getPrayerTimesForLocation(double latitude, double longitude) async {
    try {
      return await _apiService.getPrayerTimesForLocation(latitude, longitude);
    } catch (e) {
      return _getMockPrayerTimes();
    }
  }
  
  /// Get current position using GPS
  static Future<Position> _getCurrentPosition() async {
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
  
  /// Get next prayer time
  static String getNextPrayerTime(Map<String, String> prayerTimes) {
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
  static Duration getTimeUntilNextPrayer(Map<String, String> prayerTimes) {
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
      final tomorrowPrayer = prayerDateTime.add(Duration(days: 1));
      return tomorrowPrayer.difference(now);
    }
    
    return prayerDateTime.difference(now);
  }
  
  /// Check if time1 is after time2
  static bool _isTimeAfter(String time1, String time2) {
    final time1Parts = time1.split(':');
    final time2Parts = time2.split(':');
    
    final time1Minutes = int.parse(time1Parts[0]) * 60 + int.parse(time1Parts[1]);
    final time2Minutes = int.parse(time2Parts[0]) * 60 + int.parse(time2Parts[1]);
    
    return time1Minutes > time2Minutes;
  }
  
  /// Get mock prayer times for testing
  static Map<String, String> _getMockPrayerTimes() {
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
  
  /// Calculate Qibla direction
  static double calculateQiblaDirection(double latitude, double longitude) {
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
}
