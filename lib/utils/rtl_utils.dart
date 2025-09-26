import 'package:flutter/material.dart';

class RTLUtils {
  // Check if text contains Arabic characters
  static bool isArabic(String text) {
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    return arabicRegex.hasMatch(text);
  }
  
  // Get text direction based on content
  static TextDirection getTextDirection(String text) {
    return isArabic(text) ? TextDirection.rtl : TextDirection.ltr;
  }
  
  // Get appropriate font family for text
  static String getFontFamily(String text) {
    return isArabic(text) ? 'Arial' : 'Roboto'; // Using Arial for Arabic until we add proper fonts
  }
  
  // Check if locale is RTL
  static bool isRTLLocale(Locale locale) {
    return locale.languageCode == 'ar';
  }
  
  // Get text alignment based on content
  static TextAlign getTextAlign(String text) {
    return isArabic(text) ? TextAlign.right : TextAlign.left;
  }
}
