import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/hadith_models.dart';
import 'api/hadith_api_service.dart';

class HadithService {
  static final HadithApiService _apiService = HadithApiService();
  // Load Hadith Collections
  static Future<List<HadithCollection>> getHadithCollections() async {
    try {
      return await _apiService.getHadithCollections();
    } catch (e) {
      // Fallback to hardcoded data
      return [
        HadithCollection(
          name: 'Sahih Bukhari',
          description: 'The most authentic collection of hadiths',
          author: 'Imam Bukhari',
          totalHadiths: 7563,
          language: 'Arabic',
        ),
        HadithCollection(
          name: 'Sahih Muslim',
          description: 'Second most authentic collection',
          author: 'Imam Muslim',
          totalHadiths: 7563,
          language: 'Arabic',
        ),
        HadithCollection(
          name: 'Sunan Abu Dawood',
          description: 'Collection of hadiths by Abu Dawood',
          author: 'Abu Dawood',
          totalHadiths: 4800,
          language: 'Arabic',
        ),
        HadithCollection(
          name: 'Jami at-Tirmidhi',
          description: 'Collection by Imam Tirmidhi',
          author: 'Imam Tirmidhi',
          totalHadiths: 3956,
          language: 'Arabic',
        ),
        HadithCollection(
          name: 'Sunan an-Nasa\'i',
          description: 'Collection by Imam Nasa\'i',
          author: 'Imam Nasa\'i',
          totalHadiths: 5761,
          language: 'Arabic',
        ),
        HadithCollection(
          name: 'Sunan Ibn Majah',
          description: 'Collection by Ibn Majah',
          author: 'Ibn Majah',
          totalHadiths: 4341,
          language: 'Arabic',
        ),
      ];
    }
  }

  // Load Sahih Bukhari hadiths from JSON
  static Future<List<Hadith>> getSahihBukhariHadiths() async {
    try {
      final String response = await rootBundle.loadString('assets/data/hadith/sahih_bukhari.json');
      final Map<String, dynamic> data = json.decode(response);
      final List<dynamic> hadithsData = data['hadiths'];
      return hadithsData.map((json) => Hadith.fromJson(json)).toList();
    } catch (e) {
      // Fallback to hardcoded data if JSON loading fails
      return _getFallbackHadiths();
    }
  }

  // Load Sahih Muslim hadiths from JSON
  static Future<List<Hadith>> getSahihMuslimHadiths() async {
    try {
      final String response = await rootBundle.loadString('assets/data/hadith/sahih_muslim.json');
      final Map<String, dynamic> data = json.decode(response);
      final List<dynamic> hadithsData = data['hadiths'];
      return hadithsData.map((json) => Hadith.fromJson(json)).toList();
    } catch (e) {
      // Fallback to hardcoded data if JSON loading fails
      return _getFallbackHadiths();
    }
  }

  // Fallback hadith data
  static List<Hadith> _getFallbackHadiths() {
    return [
      Hadith(
        id: '1',
        collection: 'Sahih Bukhari',
        book: 'Book of Faith',
        chapter: 'Chapter 1',
        narrator: 'Abu Huraira',
        textArabic: 'قَالَ رَسُولُ اللَّهِ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ: "الإِيمَانُ بِضْعٌ وَسَبْعُونَ شُعْبَةً، فَأَفْضَلُهَا قَوْلُ لَا إِلَهَ إِلَّا اللَّهُ، وَأَدْنَاهَا إِمَاطَةُ الْأَذَى عَنِ الطَّرِيقِ، وَالْحَيَاءُ شُعْبَةٌ مِنَ الْإِيمَانِ"',
        textEnglish: 'The Messenger of Allah (peace be upon him) said: "Faith has over seventy branches, and the most excellent of them is the declaration that there is no god but Allah, and the lowest of them is the removal of what is injurious from the path, and modesty is a branch of faith."',
        grade: 'Sahih',
        tags: ['Faith', 'Modesty', 'Good Deeds'],
        reference: 'Sahih Bukhari 9',
      ),
      Hadith(
        id: '2',
        collection: 'Sahih Muslim',
        book: 'Book of Prayer',
        chapter: 'Chapter 1',
        narrator: 'Ibn Umar',
        textArabic: 'قَالَ رَسُولُ اللَّهِ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ: "بُنِيَ الْإِسْلَامُ عَلَى خَمْسٍ: شَهَادَةِ أَنْ لَا إِلَهَ إِلَّا اللَّهُ وَأَنَّ مُحَمَّدًا رَسُولُ اللَّهِ، وَإِقَامِ الصَّلَاةِ، وَإِيتَاءِ الزَّكَاةِ، وَالْحَجِّ، وَصَوْمِ رَمَضَانَ"',
        textEnglish: 'The Messenger of Allah (peace be upon him) said: "Islam is built upon five pillars: testifying that there is no god but Allah and that Muhammad ﷺ is the Messenger of Allah, establishing prayer, giving zakah, performing Hajj, and fasting in Ramadan."',
        grade: 'Sahih',
        tags: ['Islam', 'Pillars', 'Prayer', 'Zakah', 'Hajj', 'Fasting'],
        reference: 'Sahih Muslim 16',
      ),
      Hadith(
        id: '3',
        collection: 'Sahih Bukhari',
        book: 'Book of Knowledge',
        chapter: 'Chapter 1',
        narrator: 'Anas ibn Malik',
        textArabic: 'قَالَ رَسُولُ اللَّهِ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ: "طَلَبُ الْعِلْمِ فَرِيضَةٌ عَلَى كُلِّ مُسْلِمٍ"',
        textEnglish: 'The Messenger of Allah (peace be upon him) said: "Seeking knowledge is obligatory upon every Muslim."',
        grade: 'Sahih',
        tags: ['Knowledge', 'Education', 'Learning'],
        reference: 'Sahih Bukhari 1',
      ),
      Hadith(
        id: '4',
        collection: 'Sahih Muslim',
        book: 'Book of Virtues',
        chapter: 'Chapter 1',
        narrator: 'Abu Huraira',
        textArabic: 'قَالَ رَسُولُ اللَّهِ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ: "مَنْ كَانَ يُؤْمِنُ بِاللَّهِ وَالْيَوْمِ الْآخِرِ فَلْيَقُلْ خَيْرًا أَوْ لِيَصْمُتْ"',
        textEnglish: 'The Messenger of Allah (peace be upon him) said: "Whoever believes in Allah and the Last Day should speak good or remain silent."',
        grade: 'Sahih',
        tags: ['Speech', 'Good Deeds', 'Silence'],
        reference: 'Sahih Muslim 47',
      ),
      Hadith(
        id: '5',
        collection: 'Sahih Bukhari',
        book: 'Book of Manners',
        chapter: 'Chapter 1',
        narrator: 'Abu Huraira',
        textArabic: 'قَالَ رَسُولُ اللَّهِ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ: "لَا يُؤْمِنُ أَحَدُكُمْ حَتَّى يُحِبَّ لِأَخِيهِ مَا يُحِبُّ لِنَفْسِهِ"',
        textEnglish: 'The Messenger of Allah (peace be upon him) said: "None of you will have faith until he loves for his brother what he loves for himself."',
        grade: 'Sahih',
        tags: ['Love', 'Brotherhood', 'Faith'],
        reference: 'Sahih Bukhari 13',
      ),
    ];
  }

  // Get all hadiths (combines Bukhari and Muslim)
  static Future<List<Hadith>> getAllHadiths() async {
    final bukhariHadiths = await getSahihBukhariHadiths();
    final muslimHadiths = await getSahihMuslimHadiths();
    return [...bukhariHadiths, ...muslimHadiths];
  }

  // Get mock hadiths (fallback method)
  static List<Hadith> getMockHadiths() {
    return _getFallbackHadiths();
  }

  static List<Hadith> searchHadiths(String query) {
    final hadiths = getMockHadiths();
    if (query.isEmpty) return hadiths;
    
    return hadiths.where((hadith) {
      return hadith.textEnglish.toLowerCase().contains(query.toLowerCase()) ||
             hadith.textArabic.contains(query) ||
             hadith.narrator.toLowerCase().contains(query.toLowerCase()) ||
             hadith.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase()));
    }).toList();
  }

  static List<Hadith> getHadithsByCollection(String collection) {
    return getMockHadiths().where((hadith) => hadith.collection == collection).toList();
  }

  // Get unique books from a collection
  static Future<List<String>> getBooksFromCollection(String collection) async {
    try {
      List<Hadith> hadiths;
      
      if (collection == 'Sahih Bukhari') {
        hadiths = await getSahihBukhariHadiths();
      } else if (collection == 'Sahih Muslim') {
        hadiths = await getSahihMuslimHadiths();
      } else {
        hadiths = await getAllHadiths();
        hadiths = hadiths.where((h) => h.collection == collection).toList();
      }
      
      final books = hadiths.map((h) => h.book).toSet().toList();
      books.sort();
      return books;
    } catch (e) {
      // Fallback to mock data
      final hadiths = getMockHadiths().where((h) => h.collection == collection).toList();
      final books = hadiths.map((h) => h.book).toSet().toList();
      books.sort();
      return books;
    }
  }

  // Get hadiths by book from a collection
  static Future<List<Hadith>> getHadithsByBook(String collection, String book) async {
    try {
      List<Hadith> hadiths;
      
      if (collection == 'Sahih Bukhari') {
        hadiths = await getSahihBukhariHadiths();
      } else if (collection == 'Sahih Muslim') {
        hadiths = await getSahihMuslimHadiths();
      } else {
        hadiths = await getAllHadiths();
        hadiths = hadiths.where((h) => h.collection == collection).toList();
      }
      
      return hadiths.where((h) => h.book == book).toList();
    } catch (e) {
      // Fallback to mock data
      final hadiths = getMockHadiths()
          .where((h) => h.collection == collection && h.book == book)
          .toList();
      return hadiths;
    }
  }
}
