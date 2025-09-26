class PrayerTimes {
  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;
  final DateTime? ishaStart; // For some calculation methods
  final String calculationMethod;
  final String timezone;

  PrayerTimes({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    this.ishaStart,
    required this.calculationMethod,
    required this.timezone,
  });

  factory PrayerTimes.fromJson(Map<String, dynamic> json) {
    return PrayerTimes(
      fajr: DateTime.parse(json['fajr'] as String),
      sunrise: DateTime.parse(json['sunrise'] as String),
      dhuhr: DateTime.parse(json['dhuhr'] as String),
      asr: DateTime.parse(json['asr'] as String),
      maghrib: DateTime.parse(json['maghrib'] as String),
      isha: DateTime.parse(json['isha'] as String),
      ishaStart: json['ishaStart'] != null ? DateTime.parse(json['ishaStart'] as String) : null,
      calculationMethod: json['calculationMethod'] as String,
      timezone: json['timezone'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fajr': fajr.toIso8601String(),
      'sunrise': sunrise.toIso8601String(),
      'dhuhr': dhuhr.toIso8601String(),
      'asr': asr.toIso8601String(),
      'maghrib': maghrib.toIso8601String(),
      'isha': isha.toIso8601String(),
      'ishaStart': ishaStart?.toIso8601String(),
      'calculationMethod': calculationMethod,
      'timezone': timezone,
    };
  }

  // Get next prayer time
  DateTime? getNextPrayer() {
    final now = DateTime.now();
    final prayers = [fajr, dhuhr, asr, maghrib, isha];
    
    for (final prayer in prayers) {
      if (prayer.isAfter(now)) {
        return prayer;
      }
    }
    
    // If no prayer is after now, return tomorrow's fajr
    return fajr.add(const Duration(days: 1));
  }

  // Get current prayer name
  String? getCurrentPrayer() {
    final now = DateTime.now();
    
    if (now.isAfter(fajr) && now.isBefore(sunrise)) {
      return 'Fajr';
    } else if (now.isAfter(sunrise) && now.isBefore(dhuhr)) {
      return 'Sunrise';
    } else if (now.isAfter(dhuhr) && now.isBefore(asr)) {
      return 'Dhuhr';
    } else if (now.isAfter(asr) && now.isBefore(maghrib)) {
      return 'Asr';
    } else if (now.isAfter(maghrib) && now.isBefore(isha)) {
      return 'Maghrib';
    } else if (now.isAfter(isha)) {
      return 'Isha';
    }
    
    return null;
  }
}

class Location {
  final double latitude;
  final double longitude;
  final String city;
  final String country;
  final String timezone;
  final String? state;
  final String? countryCode;

  Location({
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.country,
    required this.timezone,
    this.state,
    this.countryCode,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      city: json['city'] as String,
      country: json['country'] as String,
      timezone: json['timezone'] as String,
      state: json['state'] as String?,
      countryCode: json['countryCode'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'city': city,
      'country': country,
      'timezone': timezone,
      'state': state,
      'countryCode': countryCode,
    };
  }
}

class QiblaDirection {
  final double bearing;
  final double distance;
  final String direction; // 'N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'
  final double accuracy;

  QiblaDirection({
    required this.bearing,
    required this.distance,
    required this.direction,
    required this.accuracy,
  });

  factory QiblaDirection.fromJson(Map<String, dynamic> json) {
    return QiblaDirection(
      bearing: (json['bearing'] as num).toDouble(),
      distance: (json['distance'] as num).toDouble(),
      direction: json['direction'] as String,
      accuracy: (json['accuracy'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bearing': bearing,
      'distance': distance,
      'direction': direction,
      'accuracy': accuracy,
    };
  }
}

class PrayerSettings {
  final String calculationMethod;
  final String madhab; // 'Shafi', 'Hanafi', 'Maliki', 'Hanbali'
  final bool highLatitudeAdjustment;
  final String highLatitudeMethod;
  final bool daylightSavingTime;
  final int fajrAngle;
  final int ishaAngle;
  final bool notificationsEnabled;
  final int notificationAdvanceMinutes;
  final List<String> enabledPrayers;

  PrayerSettings({
    required this.calculationMethod,
    required this.madhab,
    required this.highLatitudeAdjustment,
    required this.highLatitudeMethod,
    required this.daylightSavingTime,
    required this.fajrAngle,
    required this.ishaAngle,
    required this.notificationsEnabled,
    required this.notificationAdvanceMinutes,
    required this.enabledPrayers,
  });

  factory PrayerSettings.fromJson(Map<String, dynamic> json) {
    return PrayerSettings(
      calculationMethod: json['calculationMethod'] as String,
      madhab: json['madhab'] as String,
      highLatitudeAdjustment: json['highLatitudeAdjustment'] as bool,
      highLatitudeMethod: json['highLatitudeMethod'] as String,
      daylightSavingTime: json['daylightSavingTime'] as bool,
      fajrAngle: json['fajrAngle'] as int,
      ishaAngle: json['ishaAngle'] as int,
      notificationsEnabled: json['notificationsEnabled'] as bool,
      notificationAdvanceMinutes: json['notificationAdvanceMinutes'] as int,
      enabledPrayers: (json['enabledPrayers'] as List<dynamic>).map((prayer) => prayer as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'calculationMethod': calculationMethod,
      'madhab': madhab,
      'highLatitudeAdjustment': highLatitudeAdjustment,
      'highLatitudeMethod': highLatitudeMethod,
      'daylightSavingTime': daylightSavingTime,
      'fajrAngle': fajrAngle,
      'ishaAngle': ishaAngle,
      'notificationsEnabled': notificationsEnabled,
      'notificationAdvanceMinutes': notificationAdvanceMinutes,
      'enabledPrayers': enabledPrayers,
    };
  }
}

class PrayerNotification {
  final String id;
  final String prayerName;
  final DateTime scheduledTime;
  final bool isEnabled;
  final String title;
  final String body;
  final String? soundFile;

  PrayerNotification({
    required this.id,
    required this.prayerName,
    required this.scheduledTime,
    required this.isEnabled,
    required this.title,
    required this.body,
    this.soundFile,
  });

  factory PrayerNotification.fromJson(Map<String, dynamic> json) {
    return PrayerNotification(
      id: json['id'] as String,
      prayerName: json['prayerName'] as String,
      scheduledTime: DateTime.parse(json['scheduledTime'] as String),
      isEnabled: json['isEnabled'] as bool,
      title: json['title'] as String,
      body: json['body'] as String,
      soundFile: json['soundFile'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prayerName': prayerName,
      'scheduledTime': scheduledTime.toIso8601String(),
      'isEnabled': isEnabled,
      'title': title,
      'body': body,
      'soundFile': soundFile,
    };
  }
}
