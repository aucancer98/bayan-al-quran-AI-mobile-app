import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkService {
  static const String _bookmarksKey = 'quran_bookmarks';
  
  // Save bookmarks to local storage
  static Future<void> saveBookmarks(List<Bookmark> bookmarks) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarksJson = bookmarks.map((bookmark) => bookmark.toJson()).toList();
    await prefs.setString(_bookmarksKey, jsonEncode(bookmarksJson));
  }
  
  // Load bookmarks from local storage
  static Future<List<Bookmark>> loadBookmarks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bookmarksString = prefs.getString(_bookmarksKey);
      
      if (bookmarksString == null) {
        return [];
      }
      
      final List<dynamic> bookmarksJson = jsonDecode(bookmarksString);
      return bookmarksJson.map((json) => Bookmark.fromJson(json)).toList();
    } catch (e) {
      print('Error loading bookmarks: $e');
      return [];
    }
  }
  
  // Add a bookmark
  static Future<void> addBookmark(Bookmark bookmark) async {
    final bookmarks = await loadBookmarks();
    
    // Check if bookmark already exists
    final existingIndex = bookmarks.indexWhere(
      (b) => b.surahNumber == bookmark.surahNumber && b.ayahNumber == bookmark.ayahNumber
    );
    
    if (existingIndex == -1) {
      bookmarks.add(bookmark);
      await saveBookmarks(bookmarks);
    }
  }
  
  // Remove a bookmark
  static Future<void> removeBookmark(int surahNumber, int ayahNumber) async {
    final bookmarks = await loadBookmarks();
    bookmarks.removeWhere(
      (b) => b.surahNumber == surahNumber && b.ayahNumber == ayahNumber
    );
    await saveBookmarks(bookmarks);
  }
  
  // Check if an ayah is bookmarked
  static Future<bool> isBookmarked(int surahNumber, int ayahNumber) async {
    final bookmarks = await loadBookmarks();
    return bookmarks.any(
      (b) => b.surahNumber == surahNumber && b.ayahNumber == ayahNumber
    );
  }
  
  // Get bookmarks for a specific surah
  static Future<List<Bookmark>> getBookmarksForSurah(int surahNumber) async {
    final bookmarks = await loadBookmarks();
    return bookmarks.where((b) => b.surahNumber == surahNumber).toList();
  }
  
  // Clear all bookmarks
  static Future<void> clearAllBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_bookmarksKey);
  }
}

class Bookmark {
  final int surahNumber;
  final int ayahNumber;
  final String surahName;
  final String ayahText;
  final DateTime createdAt;
  final String? note;

  const Bookmark({
    required this.surahNumber,
    required this.ayahNumber,
    required this.surahName,
    required this.ayahText,
    required this.createdAt,
    this.note,
  });

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      surahNumber: json['surahNumber'] as int,
      ayahNumber: json['ayahNumber'] as int,
      surahName: json['surahName'] as String,
      ayahText: json['ayahText'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'surahNumber': surahNumber,
      'ayahNumber': ayahNumber,
      'surahName': surahName,
      'ayahText': ayahText,
      'createdAt': createdAt.toIso8601String(),
      'note': note,
    };
  }
}
