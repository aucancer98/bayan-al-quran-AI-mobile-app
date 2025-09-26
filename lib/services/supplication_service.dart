import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/supplication_models.dart';

class SupplicationService {
  // Load supplication categories and data from JSON
  static Future<Map<String, dynamic>> getSupplicationData() async {
    try {
      final String response = await rootBundle.loadString('assets/data/supplications/daily_adhkar.json');
      final Map<String, dynamic> data = json.decode(response);
      return data;
    } catch (e) {
      // Fallback to hardcoded data if JSON loading fails
      return _getFallbackData();
    }
  }

  static List<SupplicationCategory> getCategories() {
    return [
      SupplicationCategory(
        name: 'Morning Adhkar',
        description: 'Daily morning supplications',
        icon: 'wb_sunny',
        count: 15,
      ),
      SupplicationCategory(
        name: 'Evening Adhkar',
        description: 'Daily evening supplications',
        icon: 'nights_stay',
        count: 15,
      ),
      SupplicationCategory(
        name: 'Prayer Supplications',
        description: 'Duas for different prayers',
        icon: 'access_time',
        count: 20,
      ),
      SupplicationCategory(
        name: 'Daily Life',
        description: 'Supplications for daily activities',
        icon: 'home',
        count: 25,
      ),
      SupplicationCategory(
        name: 'Special Occasions',
        description: 'Duas for special moments',
        icon: 'celebration',
        count: 18,
      ),
      SupplicationCategory(
        name: 'Protection',
        description: 'Duas for protection and safety',
        icon: 'security',
        count: 12,
      ),
    ];
  }

  // Fallback data method
  static Map<String, dynamic> _getFallbackData() {
    return {
      'categories': getCategories(),
      'supplications': getMockSupplications(),
    };
  }

  static List<Supplication> getMockSupplications() {
    return [
      // Morning Adhkar
      Supplication(
        id: '1',
        title: 'Morning Remembrance',
        arabicText: 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
        englishText: 'We have reached the morning and the dominion belongs to Allah, and all praise is for Allah. There is no god but Allah alone, with no partner. To Him belongs the dominion and to Him belongs all praise, and He is over all things competent.',
        transliteration: 'Asbahna wa asbahal mulku lillah, wal hamdu lillah, la ilaha illa Allah wahdahu la sharika lah, lahul mulku wa lahul hamd wa huwa ala kulli shay\'in qadeer.',
        category: 'Morning Adhkar',
        context: 'Upon waking up in the morning',
        audioUrl: '',
        repetition: 1,
        benefits: ['Protection throughout the day', 'Blessings in daily activities', 'Remembrance of Allah'],
        reference: 'Sahih Muslim 2723',
      ),
      Supplication(
        id: '2',
        title: 'Seeking Forgiveness',
        arabicText: 'أَسْتَغْفِرُ اللَّهَ وَأَتُوبُ إِلَيْهِ',
        englishText: 'I seek forgiveness from Allah and repent to Him.',
        transliteration: 'Astaghfirullah wa atubu ilayh.',
        category: 'Morning Adhkar',
        context: 'Morning remembrance',
        audioUrl: '',
        repetition: 100,
        benefits: ['Forgiveness of sins', 'Purification of heart', 'Divine mercy'],
        reference: 'Sahih Bukhari 6307',
      ),
      Supplication(
        id: '3',
        title: 'Praise and Gratitude',
        arabicText: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
        englishText: 'All praise is due to Allah, Lord of the worlds.',
        transliteration: 'Alhamdulillahi rabbil alameen.',
        category: 'Morning Adhkar',
        context: 'Morning remembrance',
        audioUrl: '',
        repetition: 33,
        benefits: ['Gratitude to Allah', 'Blessings in life', 'Contentment'],
        reference: 'Quran 1:2',
      ),

      // Evening Adhkar
      Supplication(
        id: '4',
        title: 'Evening Remembrance',
        arabicText: 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
        englishText: 'We have reached the evening and the dominion belongs to Allah, and all praise is for Allah. There is no god but Allah alone, with no partner. To Him belongs the dominion and to Him belongs all praise, and He is over all things competent.',
        transliteration: 'Amsayna wa amsal mulku lillah, wal hamdu lillah, la ilaha illa Allah wahdahu la sharika lah, lahul mulku wa lahul hamd wa huwa ala kulli shay\'in qadeer.',
        category: 'Evening Adhkar',
        context: 'Upon reaching the evening',
        audioUrl: '',
        repetition: 1,
        benefits: ['Protection throughout the night', 'Peaceful sleep', 'Divine protection'],
        reference: 'Sahih Muslim 2723',
      ),
      Supplication(
        id: '5',
        title: 'Seeking Refuge',
        arabicText: 'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ',
        englishText: 'I seek refuge in the perfect words of Allah from the evil of what He has created.',
        transliteration: 'A\'udhu bi kalimatillahit tammati min sharri ma khalaq.',
        category: 'Evening Adhkar',
        context: 'Before sleeping',
        audioUrl: '',
        repetition: 3,
        benefits: ['Protection from harm', 'Safe sleep', 'Divine shelter'],
        reference: 'Sahih Muslim 2708',
      ),

      // Prayer Supplications
      Supplication(
        id: '6',
        title: 'Before Prayer',
        arabicText: 'اللَّهُمَّ بَاعِدْ بَيْنِي وَبَيْنَ خَطَايَايَ كَمَا بَاعَدْتَ بَيْنَ الْمَشْرِقِ وَالْمَغْرِبِ',
        englishText: 'O Allah, distance me from my sins as You have distanced the East from the West.',
        transliteration: 'Allahumma ba\'id bayni wa bayna khatayaya kama ba\'adta baynal mashriqi wal maghrib.',
        category: 'Prayer Supplications',
        context: 'Before starting prayer',
        audioUrl: '',
        repetition: 1,
        benefits: ['Purification before prayer', 'Forgiveness of sins', 'Spiritual preparation'],
        reference: 'Sahih Bukhari 744',
      ),
      Supplication(
        id: '7',
        title: 'After Prayer',
        arabicText: 'سُبْحَانَ اللَّهِ، وَالْحَمْدُ لِلَّهِ، وَلَا إِلَهَ إِلَّا اللَّهُ، وَاللَّهُ أَكْبَرُ',
        englishText: 'Glory be to Allah, and all praise is due to Allah, and there is no god but Allah, and Allah is the Greatest.',
        transliteration: 'Subhanallah, wal hamdulillah, wa la ilaha illa Allah, wallahu akbar.',
        category: 'Prayer Supplications',
        context: 'After completing prayer',
        audioUrl: '',
        repetition: 33,
        benefits: ['Completion of prayer', 'Remembrance of Allah', 'Spiritual fulfillment'],
        reference: 'Sahih Muslim 596',
      ),

      // Daily Life
      Supplication(
        id: '8',
        title: 'Before Eating',
        arabicText: 'بِسْمِ اللَّهِ',
        englishText: 'In the name of Allah.',
        transliteration: 'Bismillah.',
        category: 'Daily Life',
        context: 'Before starting to eat',
        audioUrl: '',
        repetition: 1,
        benefits: ['Blessing in food', 'Protection from harm', 'Gratitude to Allah'],
        reference: 'Sahih Bukhari 5376',
      ),
      Supplication(
        id: '9',
        title: 'After Eating',
        arabicText: 'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنَا وَسَقَانَا وَجَعَلَنَا مُسْلِمِينَ',
        englishText: 'All praise is due to Allah who has fed us and given us drink and made us Muslims.',
        transliteration: 'Alhamdulillahil ladhi at\'amana wa saqana wa ja\'alana muslimeen.',
        category: 'Daily Life',
        context: 'After finishing eating',
        audioUrl: '',
        repetition: 1,
        benefits: ['Gratitude for sustenance', 'Blessing in food', 'Thankfulness'],
        reference: 'Sunan Abu Dawood 3850',
      ),
      Supplication(
        id: '10',
        title: 'Before Sleeping',
        arabicText: 'بِاسْمِكَ رَبِّي وَضَعْتُ جَنْبِي، وَبِكَ أَرْفَعُهُ، فَإِنْ أَمْسَكْتَ نَفْسِي فَارْحَمْهَا، وَإِنْ أَرْسَلْتَهَا فَاحْفَظْهَا بِمَا تَحْفَظُ بِهِ عِبَادَكَ الصَّالِحِينَ',
        englishText: 'In Your name, my Lord, I lie down and in Your name I rise, so if You should take my soul then have mercy upon it, and if You should return my soul then protect it in the manner You do so with Your righteous servants.',
        transliteration: 'Bismika rabbi wada\'tu janbi, wa bika arfa\'uh, fa in amsakta nafsi farhamha, wa in arsaltaha fahfazha bima tahfazu bihi ibadakas saliheen.',
        category: 'Daily Life',
        context: 'Before going to sleep',
        audioUrl: '',
        repetition: 1,
        benefits: ['Peaceful sleep', 'Divine protection', 'Trust in Allah'],
        reference: 'Sahih Bukhari 6320',
      ),

      // Special Occasions
      Supplication(
        id: '11',
        title: 'Travel Supplication',
        arabicText: 'سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ، وَإِنَّا إِلَى رَبِّنَا لَمُنْقَلِبُونَ',
        englishText: 'Glory be to Him who has subjected this to us, and we were not able to do it. And indeed, to our Lord we will return.',
        transliteration: 'Subhanal ladhi sakhkhara lana hadha wa ma kunna lahu muqrineen, wa inna ila rabbina lamunqaliboon.',
        category: 'Special Occasions',
        context: 'When traveling',
        audioUrl: '',
        repetition: 1,
        benefits: ['Safe journey', 'Gratitude for transportation', 'Trust in Allah'],
        reference: 'Quran 43:13-14',
      ),
      Supplication(
        id: '12',
        title: 'Wedding Supplication',
        arabicText: 'بَارَكَ اللَّهُ لَكَ وَبَارَكَ عَلَيْكَ وَجَمَعَ بَيْنَكُمَا فِي خَيْرٍ',
        englishText: 'May Allah bless you and bestow His blessings upon you and unite you both in goodness.',
        transliteration: 'Barakallahu laka wa baraka alayka wa jama\'a baynakuma fi khayr.',
        category: 'Special Occasions',
        context: 'At weddings',
        audioUrl: '',
        repetition: 1,
        benefits: ['Blessings in marriage', 'Unity and harmony', 'Divine favor'],
        reference: 'Sunan Abu Dawood 2130',
      ),

      // Protection
      Supplication(
        id: '13',
        title: 'Protection from Evil',
        arabicText: 'أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ',
        englishText: 'I seek refuge in Allah from Satan, the accursed.',
        transliteration: 'A\'udhu billahi minash shaytanir rajeem.',
        category: 'Protection',
        context: 'When feeling threatened or before important tasks',
        audioUrl: '',
        repetition: 1,
        benefits: ['Protection from evil', 'Shield from Satan', 'Divine refuge'],
        reference: 'Quran 16:98',
      ),
      Supplication(
        id: '14',
        title: 'General Protection',
        arabicText: 'حَسْبِيَ اللَّهُ لَا إِلَهَ إِلَّا هُوَ عَلَيْهِ تَوَكَّلْتُ وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ',
        englishText: 'Sufficient for me is Allah; there is no deity except Him. On Him I have relied, and He is the Lord of the Great Throne.',
        transliteration: 'Hasbiyallahu la ilaha illa huwa alayhi tawakkaltu wa huwa rabbul arshil azeem.',
        category: 'Protection',
        context: 'When facing difficulties or challenges',
        audioUrl: '',
        repetition: 7,
        benefits: ['Divine sufficiency', 'Trust in Allah', 'Protection from harm'],
        reference: 'Quran 9:129',
      ),
    ];
  }

  static List<Supplication> getSupplicationsByCategory(String category) {
    return getMockSupplications().where((supplication) => supplication.category == category).toList();
  }

  static List<Supplication> searchSupplications(String query) {
    final supplications = getMockSupplications();
    if (query.isEmpty) return supplications;
    
    return supplications.where((supplication) {
      return supplication.title.toLowerCase().contains(query.toLowerCase()) ||
             supplication.englishText.toLowerCase().contains(query.toLowerCase()) ||
             supplication.arabicText.contains(query) ||
             supplication.category.toLowerCase().contains(query.toLowerCase()) ||
             supplication.context.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
