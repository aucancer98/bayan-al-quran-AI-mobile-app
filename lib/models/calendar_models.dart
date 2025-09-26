class IslamicDate {
  final int year;
  final int month;
  final int day;
  final String monthName;
  final String dayName;
  final bool isHoliday;
  final String? holidayName;
  final String? holidayDescription;

  IslamicDate({
    required this.year,
    required this.month,
    required this.day,
    required this.monthName,
    required this.dayName,
    this.isHoliday = false,
    this.holidayName,
    this.holidayDescription,
  });
}

class IslamicEvent {
  final String id;
  final String name;
  final String description;
  final DateTime date;
  final String type; // 'religious', 'historical', 'cultural'
  final String importance; // 'high', 'medium', 'low'
  final List<String> traditions;

  IslamicEvent({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.type,
    required this.importance,
    required this.traditions,
  });

  factory IslamicEvent.fromJson(Map<String, dynamic> json) {
    return IslamicEvent(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      type: json['type'] as String,
      importance: json['importance'] as String,
      traditions: (json['traditions'] as List<dynamic>).map((tradition) => tradition as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'date': date.toIso8601String(),
      'type': type,
      'importance': importance,
      'traditions': traditions,
    };
  }
}

class IslamicMonth {
  final int number;
  final String name;
  final String arabicName;
  final String description;
  final int days;
  final List<String> significantEvents;

  IslamicMonth({
    required this.number,
    required this.name,
    required this.arabicName,
    required this.description,
    required this.days,
    required this.significantEvents,
  });
}
