class Surah {
  final int number;
  final String nameArabic;
  final String nameEnglish;
  final String nameTransliterated;
  final int ayahCount;
  final String revelationType; // Meccan/Medinan
  final int revelationOrder;
  final String? description;

  const Surah({
    required this.number,
    required this.nameArabic,
    required this.nameEnglish,
    required this.nameTransliterated,
    required this.ayahCount,
    required this.revelationType,
    required this.revelationOrder,
    this.description,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      number: json['number'] as int,
      nameArabic: json['nameArabic'] as String,
      nameEnglish: json['nameEnglish'] as String,
      nameTransliterated: json['nameTransliterated'] as String,
      ayahCount: json['ayahCount'] as int,
      revelationType: json['revelationType'] as String,
      revelationOrder: json['revelationOrder'] as int,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'nameArabic': nameArabic,
      'nameEnglish': nameEnglish,
      'nameTransliterated': nameTransliterated,
      'ayahCount': ayahCount,
      'revelationType': revelationType,
      'revelationOrder': revelationOrder,
      'description': description,
    };
  }
}

class Ayah {
  final int surahNumber;
  final int ayahNumber;
  final String arabicText;
  final List<Word> words;
  final List<Translation> translations;
  final int juz;
  final int hizb;
  final int rub;
  final String tafsir;

  const Ayah({
    required this.surahNumber,
    required this.ayahNumber,
    required this.arabicText,
    required this.words,
    required this.translations,
    required this.juz,
    required this.hizb,
    required this.rub,
    required this.tafsir,
  });

  factory Ayah.fromJson(Map<String, dynamic> json) {
    return Ayah(
      surahNumber: json['surahNumber'] as int,
      ayahNumber: json['ayahNumber'] as int,
      arabicText: json['arabicText'] as String,
      words: (json['words'] as List<dynamic>)
          .map((word) => Word.fromJson(word as Map<String, dynamic>))
          .toList(),
      translations: (json['translations'] as List<dynamic>)
          .map((translation) => Translation.fromJson(translation as Map<String, dynamic>))
          .toList(),
      juz: json['juz'] as int,
      hizb: json['hizb'] as int,
      rub: json['rub'] as int,
      tafsir: json['tafsir'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'surahNumber': surahNumber,
      'ayahNumber': ayahNumber,
      'arabicText': arabicText,
      'words': words.map((word) => word.toJson()).toList(),
      'translations': translations.map((translation) => translation.toJson()).toList(),
      'juz': juz,
      'hizb': hizb,
      'rub': rub,
      'tafsir': tafsir,
    };
  }
}

class Word {
  final String arabic;
  final String transliteration;
  final String root;
  final String meaning;
  final String contextualMeaning;
  final int position;
  final List<String> relatedWords;
  final String partOfSpeech;
  final String grammar;

  const Word({
    required this.arabic,
    required this.transliteration,
    required this.root,
    required this.meaning,
    required this.contextualMeaning,
    required this.position,
    required this.relatedWords,
    required this.partOfSpeech,
    required this.grammar,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      arabic: json['arabic'] as String,
      transliteration: json['transliteration'] as String,
      root: json['root'] as String,
      meaning: json['meaning'] as String,
      contextualMeaning: json['contextualMeaning'] as String,
      position: json['position'] as int,
      relatedWords: (json['relatedWords'] as List<dynamic>)
          .map((word) => word as String)
          .toList(),
      partOfSpeech: json['partOfSpeech'] as String,
      grammar: json['grammar'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'arabic': arabic,
      'transliteration': transliteration,
      'root': root,
      'meaning': meaning,
      'contextualMeaning': contextualMeaning,
      'position': position,
      'relatedWords': relatedWords,
      'partOfSpeech': partOfSpeech,
      'grammar': grammar,
    };
  }
}

class Translation {
  final String translator;
  final String language;
  final String text;
  final String source;

  const Translation({
    required this.translator,
    required this.language,
    required this.text,
    required this.source,
  });

  factory Translation.fromJson(Map<String, dynamic> json) {
    return Translation(
      translator: json['translator'] as String,
      language: json['language'] as String,
      text: json['text'] as String,
      source: json['source'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'translator': translator,
      'language': language,
      'text': text,
      'source': source,
    };
  }
}
