import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hijri_date_time/hijri_date_time.dart';
import '../models/calendar_models.dart';

class CalendarService {
  // Load Islamic months data from JSON
  static Future<Map<String, dynamic>> getIslamicCalendarData() async {
    try {
      final String response = await rootBundle.loadString('assets/data/calendar/islamic_months.json');
      final Map<String, dynamic> data = json.decode(response);
      return data;
    } catch (e) {
      // Fallback to hardcoded data if JSON loading fails
      return _getFallbackCalendarData();
    }
  }

  static List<IslamicMonth> getIslamicMonths() {
    return [
      IslamicMonth(
        number: 1,
        name: 'Muharram',
        arabicName: 'مُحَرَّم',
        description: 'The first month of the Islamic calendar, considered sacred',
        days: 30,
        significantEvents: ['Ashura (10th Muharram)', 'New Islamic Year'],
      ),
      IslamicMonth(
        number: 2,
        name: 'Safar',
        arabicName: 'صَفَر',
        description: 'The second month of the Islamic calendar',
        days: 29,
        significantEvents: ['Birth of Imam Hasan (8th Safar)', 'Death of Prophet Muhammad ﷺ (28th Safar)'],
      ),
      IslamicMonth(
        number: 3,
        name: 'Rabi\' al-Awwal',
        arabicName: 'رَبِيع الأَوَّل',
        description: 'The third month, known for the birth of Prophet Muhammad ﷺ',
        days: 30,
        significantEvents: ['Birth of Prophet Muhammad ﷺ (12th Rabi\' al-Awwal)', 'Hijra to Medina'],
      ),
      IslamicMonth(
        number: 4,
        name: 'Rabi\' al-Thani',
        arabicName: 'رَبِيع الثَّانِي',
        description: 'The fourth month of the Islamic calendar',
        days: 29,
        significantEvents: ['Birth of Imam Hasan al-Askari (8th Rabi\' al-Thani)'],
      ),
      IslamicMonth(
        number: 5,
        name: 'Jumada al-Awwal',
        arabicName: 'جُمَادَى الأَوَّل',
        description: 'The fifth month of the Islamic calendar',
        days: 30,
        significantEvents: ['Birth of Fatima al-Zahra (20th Jumada al-Awwal)'],
      ),
      IslamicMonth(
        number: 6,
        name: 'Jumada al-Thani',
        arabicName: 'جُمَادَى الثَّانِي',
        description: 'The sixth month of the Islamic calendar',
        days: 29,
        significantEvents: ['Death of Fatima al-Zahra (3rd Jumada al-Thani)'],
      ),
      IslamicMonth(
        number: 7,
        name: 'Rajab',
        arabicName: 'رَجَب',
        description: 'The seventh month, one of the sacred months',
        days: 30,
        significantEvents: ['Isra and Mi\'raj (27th Rajab)', 'Birth of Imam Ali (13th Rajab)'],
      ),
      IslamicMonth(
        number: 8,
        name: 'Sha\'ban',
        arabicName: 'شَعْبَان',
        description: 'The eighth month, known for the Night of Bara\'ah',
        days: 29,
        significantEvents: ['Laylat al-Bara\'ah (15th Sha\'ban)', 'Birth of Imam Mahdi (15th Sha\'ban)'],
      ),
      IslamicMonth(
        number: 9,
        name: 'Ramadan',
        arabicName: 'رَمَضَان',
        description: 'The ninth month, the month of fasting',
        days: 30,
        significantEvents: ['Laylat al-Qadr (27th Ramadan)', 'First revelation of Quran'],
      ),
      IslamicMonth(
        number: 10,
        name: 'Shawwal',
        arabicName: 'شَوَّال',
        description: 'The tenth month, following Ramadan',
        days: 29,
        significantEvents: ['Eid al-Fitr (1st Shawwal)', 'Battle of Uhud (7th Shawwal)'],
      ),
      IslamicMonth(
        number: 11,
        name: 'Dhu al-Qi\'dah',
        arabicName: 'ذُو القِعْدَة',
        description: 'The eleventh month, one of the sacred months',
        days: 30,
        significantEvents: ['Sacred month for pilgrimage preparation'],
      ),
      IslamicMonth(
        number: 12,
        name: 'Dhu al-Hijjah',
        arabicName: 'ذُو الحِجَّة',
        description: 'The twelfth month, the month of Hajj',
        days: 29,
        significantEvents: ['Hajj pilgrimage (8th-13th Dhu al-Hijjah)', 'Eid al-Adha (10th Dhu al-Hijjah)', 'Day of Arafah (9th Dhu al-Hijjah)'],
      ),
    ];
  }

  // Fallback calendar data
  static Map<String, dynamic> _getFallbackCalendarData() {
    return {
      'months': getIslamicMonths(),
      'events': getUpcomingEvents(),
    };
  }

  static List<IslamicEvent> getUpcomingEvents() {
    final now = DateTime.now();
    return [
      IslamicEvent(
        id: '1',
        name: 'Laylat al-Qadr',
        description: 'The Night of Power, when the Quran was first revealed',
        date: DateTime(now.year, 4, 27), // Approximate date
        type: 'religious',
        importance: 'high',
        traditions: ['Night prayer', 'Quran recitation', 'Supplications', 'Charity'],
      ),
      IslamicEvent(
        id: '2',
        name: 'Eid al-Fitr',
        description: 'Festival of Breaking the Fast, marking the end of Ramadan',
        date: DateTime(now.year, 4, 10), // Approximate date
        type: 'religious',
        importance: 'high',
        traditions: ['Eid prayer', 'Gift giving', 'Family gatherings', 'Special meals'],
      ),
      // Add some test events for current month and common dates
      IslamicEvent(
        id: 'test_1',
        name: 'Test Event - Today',
        description: 'This is a test event for today',
        date: DateTime.now(),
        type: 'test',
        importance: 'medium',
        traditions: ['Testing the calendar'],
      ),
      IslamicEvent(
        id: 'test_2',
        name: 'Test Event - Tomorrow',
        description: 'This is a test event for tomorrow',
        date: DateTime.now().add(const Duration(days: 1)),
        type: 'test',
        importance: 'low',
        traditions: ['Testing the calendar'],
      ),
      IslamicEvent(
        id: 'test_3',
        name: 'Test Event - Day After',
        description: 'This is a test event for the day after tomorrow',
        date: DateTime.now().add(const Duration(days: 2)),
        type: 'test',
        importance: 'high',
        traditions: ['Testing the calendar'],
      ),
      IslamicEvent(
        id: '3',
        name: 'Eid al-Adha',
        description: 'Festival of Sacrifice, commemorating Prophet Ibrahim\'s willingness to sacrifice his son',
        date: DateTime(now.year, 6, 16), // Approximate date
        type: 'religious',
        importance: 'high',
        traditions: ['Eid prayer', 'Animal sacrifice', 'Charity', 'Pilgrimage'],
      ),
      IslamicEvent(
        id: '4',
        name: 'Ashura',
        description: 'The 10th day of Muharram, commemorating various historical events',
        date: DateTime(now.year, 7, 16), // Approximate date
        type: 'religious',
        importance: 'high',
        traditions: ['Fasting', 'Charity', 'Commemoration', 'Reflection'],
      ),
      IslamicEvent(
        id: '5',
        name: 'Mawlid an-Nabi',
        description: 'Birthday of Prophet Muhammad ﷺ (peace be upon him)',
        date: DateTime(now.year, 9, 27), // Approximate date
        type: 'religious',
        importance: 'medium',
        traditions: ['Recitation of Quran', 'Poetry about the Prophet', 'Charity', 'Community gatherings'],
      ),
      IslamicEvent(
        id: '6',
        name: 'Isra and Mi\'raj',
        description: 'The Night Journey and Ascension of Prophet Muhammad ﷺ',
        date: DateTime(now.year, 2, 8), // Approximate date
        type: 'religious',
        importance: 'medium',
        traditions: ['Night prayer', 'Reflection on the journey', 'Storytelling'],
      ),
      IslamicEvent(
        id: '7',
        name: 'Laylat al-Bara\'ah',
        description: 'The Night of Forgiveness, when Allah forgives sins',
        date: DateTime(now.year, 3, 15), // Approximate date
        type: 'religious',
        importance: 'medium',
        traditions: ['Night prayer', 'Seeking forgiveness', 'Charity', 'Visiting graves'],
      ),
      IslamicEvent(
        id: '8',
        name: 'Day of Arafah',
        description: 'The day of standing at Mount Arafat during Hajj',
        date: DateTime(now.year, 6, 15), // Approximate date
        type: 'religious',
        importance: 'high',
        traditions: ['Fasting (for non-pilgrims)', 'Supplications', 'Repentance', 'Pilgrimage'],
      ),
    ];
  }

  static IslamicDate getCurrentIslamicDate() {
    final now = DateTime.now();
    return _gregorianToIslamic(now);
  }

  // Convert Gregorian date to Islamic date using hijri_date_time package
  static IslamicDate _gregorianToIslamic(DateTime gregorianDate) {
    try {
      // Use the hijri_date_time package for accurate conversion
      final hijriDate = HijriDateTime.fromGregorian(gregorianDate);
      
      // Get day name
      final dayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
      final dayName = dayNames[gregorianDate.weekday - 1];
      
      return IslamicDate(
        year: hijriDate.year,
        month: hijriDate.month,
        day: hijriDate.day,
        monthName: getMonthName(hijriDate.month),
        dayName: dayName,
      );
    } catch (e) {
      // Fallback to approximate calculation if package fails
      return _fallbackGregorianToIslamic(gregorianDate);
    }
  }

  // Fallback method for Islamic date calculation
  static IslamicDate _fallbackGregorianToIslamic(DateTime gregorianDate) {
    // Islamic calendar epoch: July 16, 622 CE (Gregorian)
    final islamicEpoch = DateTime(622, 7, 16);
    
    // Calculate days since Islamic epoch
    final daysSinceEpoch = gregorianDate.difference(islamicEpoch).inDays;
    
    // Islamic year calculation (approximate)
    final islamicYear = (daysSinceEpoch / 354.37).floor() + 1;
    
    // Calculate remaining days in the current Islamic year
    final daysInCurrentYear = daysSinceEpoch - ((islamicYear - 1) * 354.37).floor();
    
    // Islamic month calculation (approximate)
    int islamicMonth = 1;
    int remainingDays = daysInCurrentYear.toInt();
    
    // Islamic months with their approximate lengths
    final monthLengths = [30, 29, 30, 29, 30, 29, 30, 29, 30, 29, 30, 29];
    
    for (int i = 0; i < 12; i++) {
      if (remainingDays <= monthLengths[i]) {
        islamicMonth = i + 1;
        break;
      }
      remainingDays -= monthLengths[i];
    }
    
    final islamicDay = remainingDays + 1;
    
    // Get day name
    final dayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final dayName = dayNames[gregorianDate.weekday - 1];
    
    return IslamicDate(
      year: islamicYear,
      month: islamicMonth,
      day: islamicDay,
      monthName: getMonthName(islamicMonth),
      dayName: dayName,
    );
  }

  static List<IslamicEvent> getEventsForMonth(int month) {
    return getUpcomingEvents().where((event) => event.date.month == month).toList();
  }

  static List<IslamicEvent> getEventsForDate(DateTime date) {
    return getUpcomingEvents().where((event) => 
      event.date.year == date.year && 
      event.date.month == date.month && 
      event.date.day == date.day
    ).toList();
  }

  // Load comprehensive Islamic calendar data from JSON
  static Future<List<IslamicEvent>> getEventsForDateAsync(DateTime date) async {
    try {
      final data = await getIslamicCalendarData();
      final List<IslamicEvent> events = [];
      
      // Get monthly events
      final months = data['months'] as List<dynamic>;
      for (final monthData in months) {
        final monthNumber = monthData['number'] as int;
        final significantEvents = monthData['significantEvents'] as List<dynamic>;
        
        for (final eventData in significantEvents) {
          final day = eventData['day'] as int;
          final currentYear = DateTime.now().year;
          final eventDate = DateTime(currentYear, monthNumber, day);
          
          if (eventDate.year == date.year && 
              eventDate.month == date.month && 
              eventDate.day == date.day) {
            final event = IslamicEvent(
              id: '${monthNumber}_${day}',
              name: eventData['name'] as String,
              description: eventData['description'] as String,
              date: eventDate,
              type: eventData['type'] as String,
              importance: eventData['importance'] as String,
              traditions: (eventData['traditions'] as List<dynamic>).map((t) => t as String).toList(),
            );
            events.add(event);
          }
        }
      }
      
      // Add general events for the specific date
      final generalEvents = data['generalEvents'] as List<dynamic>;
      for (final eventData in generalEvents) {
        final frequency = eventData['frequency'] as String?;
        final eventName = eventData['name'] as String;
        
        if (frequency == 'weekly' && eventName.contains('Friday')) {
          // Only add Friday prayer if the date is actually a Friday
          if (date.weekday == 5) { // Friday is weekday 5
            final event = IslamicEvent(
              id: 'friday_${date.millisecondsSinceEpoch}',
              name: eventName,
              description: eventData['description'] as String,
              date: date,
              type: eventData['type'] as String,
              importance: eventData['importance'] as String,
              traditions: (eventData['traditions'] as List<dynamic>).map((t) => t as String).toList(),
            );
            events.add(event);
          }
        } else if (frequency == 'daily') {
          // Add daily events for any date
          final event = IslamicEvent(
            id: 'daily_${eventName}_${date.millisecondsSinceEpoch}',
            name: eventName,
            description: eventData['description'] as String,
            date: date,
            type: eventData['type'] as String,
            importance: eventData['importance'] as String,
            traditions: (eventData['traditions'] as List<dynamic>).map((t) => t as String).toList(),
          );
          events.add(event);
        }
      }
      
      return events;
    } catch (e) {
      // Fallback to hardcoded events
      return getEventsForDate(date);
    }
  }

  // Load all events from JSON
  static Future<List<IslamicEvent>> getAllEventsAsync() async {
    try {
      final data = await getIslamicCalendarData();
      final months = data['months'] as List<dynamic>;
      final List<IslamicEvent> allEvents = [];
      
      // Extract events from each month
      for (final monthData in months) {
        final monthNumber = monthData['number'] as int;
        final significantEvents = monthData['significantEvents'] as List<dynamic>;
        
        for (final eventData in significantEvents) {
          final day = eventData['day'] as int;
          // Create a date for this year (we'll use current year for display)
          // Note: monthNumber is Islamic month (1-12), we need to map it to a Gregorian month
          // For now, we'll use the Islamic month number as Gregorian month for simplicity
          // In a real app, you'd want to convert Islamic dates to Gregorian dates
          final currentYear = DateTime.now().year;
          final eventDate = DateTime(currentYear, monthNumber, day);
          
          final event = IslamicEvent(
            id: '${monthNumber}_${day}',
            name: eventData['name'] as String,
            description: eventData['description'] as String,
            date: eventDate,
            type: eventData['type'] as String,
            importance: eventData['importance'] as String,
            traditions: (eventData['traditions'] as List<dynamic>).map((t) => t as String).toList(),
          );
          allEvents.add(event);
        }
      }
      
      // Add general events with proper frequency handling
      final generalEvents = data['generalEvents'] as List<dynamic>;
      for (final eventData in generalEvents) {
        final frequency = eventData['frequency'] as String?;
        final eventName = eventData['name'] as String;
        
        if (frequency == 'weekly' && eventName.contains('Friday')) {
          // Only add Friday prayer events for actual Fridays
          final currentDate = DateTime.now();
          final startOfWeek = currentDate.subtract(Duration(days: currentDate.weekday - 1));
          
          // Generate Friday events for the next 4 weeks
          for (int week = 0; week < 4; week++) {
            final fridayDate = startOfWeek.add(Duration(days: 4 + (week * 7))); // Friday is day 5 (1-indexed)
            
            final event = IslamicEvent(
              id: 'friday_${fridayDate.millisecondsSinceEpoch}',
              name: eventName,
              description: eventData['description'] as String,
              date: fridayDate,
              type: eventData['type'] as String,
              importance: eventData['importance'] as String,
              traditions: (eventData['traditions'] as List<dynamic>).map((t) => t as String).toList(),
            );
            allEvents.add(event);
          }
        } else if (frequency == 'daily') {
          // Add daily events for today and next few days
          for (int day = 0; day < 7; day++) {
            final eventDate = DateTime.now().add(Duration(days: day));
            
            final event = IslamicEvent(
              id: 'daily_${eventName}_${eventDate.millisecondsSinceEpoch}',
              name: eventName,
              description: eventData['description'] as String,
              date: eventDate,
              type: eventData['type'] as String,
              importance: eventData['importance'] as String,
              traditions: (eventData['traditions'] as List<dynamic>).map((t) => t as String).toList(),
            );
            allEvents.add(event);
          }
        } else {
          // Add one-time events
          final event = IslamicEvent(
            id: 'general_${eventName}',
            name: eventName,
            description: eventData['description'] as String,
            date: DateTime.now(),
            type: eventData['type'] as String,
            importance: eventData['importance'] as String,
            traditions: (eventData['traditions'] as List<dynamic>).map((t) => t as String).toList(),
          );
          allEvents.add(event);
        }
      }
      
      return allEvents;
    } catch (e) {
      // Fallback to hardcoded events
      return getUpcomingEvents();
    }
  }

  // Get events for a specific Islamic month
  static Future<List<IslamicEvent>> getEventsForIslamicMonth(int islamicMonth) async {
    try {
      final data = await getIslamicCalendarData();
      final months = data['months'] as List<dynamic>;
      final List<IslamicEvent> monthEvents = [];
      
      // Find the specific month
      final monthData = months.firstWhere((m) => m['number'] == islamicMonth);
      final significantEvents = monthData['significantEvents'] as List<dynamic>;
      
      for (final eventData in significantEvents) {
        final day = eventData['day'] as int;
        final currentYear = DateTime.now().year;
        final eventDate = DateTime(currentYear, islamicMonth, day);
        
        final event = IslamicEvent(
          id: '${islamicMonth}_${day}',
          name: eventData['name'] as String,
          description: eventData['description'] as String,
          date: eventDate,
          type: eventData['type'] as String,
          importance: eventData['importance'] as String,
          traditions: (eventData['traditions'] as List<dynamic>).map((t) => t as String).toList(),
        );
        monthEvents.add(event);
      }
      
      return monthEvents;
    } catch (e) {
      return [];
    }
  }

  // Get month information
  static Future<Map<String, dynamic>?> getIslamicMonthInfo(int monthNumber) async {
    try {
      final data = await getIslamicCalendarData();
      final months = data['months'] as List<dynamic>;
      
      final monthData = months.firstWhere((m) => m['number'] == monthNumber);
      return {
        'name': monthData['name'],
        'arabicName': monthData['arabicName'],
        'description': monthData['description'],
        'significance': monthData['significance'],
        'recommendedActs': monthData['recommendedActs'],
      };
    } catch (e) {
      return null;
    }
  }

  static String getMonthName(int monthNumber) {
    final months = getIslamicMonths();
    try {
      final month = months.firstWhere((m) => m.number == monthNumber);
      return month.name;
    } catch (e) {
      return 'Unknown Month';
    }
  }

  static String getMonthArabicName(int monthNumber) {
    final months = getIslamicMonths();
    try {
      final month = months.firstWhere((m) => m.number == monthNumber);
      return month.arabicName;
    } catch (e) {
      return 'شهر غير معروف';
    }
  }
}
