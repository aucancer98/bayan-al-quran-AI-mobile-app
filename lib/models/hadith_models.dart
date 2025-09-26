class Hadith {
  final String id;
  final String collection;
  final String book;
  final String chapter;
  final String narrator;
  final String textArabic;
  final String textEnglish;
  final String grade;
  final List<String> tags;
  final String reference;

  Hadith({
    required this.id,
    required this.collection,
    required this.book,
    required this.chapter,
    required this.narrator,
    required this.textArabic,
    required this.textEnglish,
    required this.grade,
    required this.tags,
    required this.reference,
  });

  factory Hadith.fromJson(Map<String, dynamic> json) {
    return Hadith(
      id: json['id']?.toString() ?? '',
      collection: json['collection']?.toString() ?? '',
      book: json['book']?.toString() ?? '',
      chapter: json['chapter']?.toString() ?? '',
      narrator: json['narrator']?.toString() ?? '',
      textArabic: json['textArabic']?.toString() ?? '',
      textEnglish: json['textEnglish']?.toString() ?? '',
      grade: json['grade']?.toString() ?? '',
      tags: (json['tags'] as List<dynamic>?)?.map((tag) => tag?.toString() ?? '').toList() ?? [],
      reference: json['reference']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'collection': collection,
      'book': book,
      'chapter': chapter,
      'narrator': narrator,
      'textArabic': textArabic,
      'textEnglish': textEnglish,
      'grade': grade,
      'tags': tags,
      'reference': reference,
    };
  }
}

class HadithCollection {
  final String name;
  final String description;
  final String author;
  final int totalHadiths;
  final String language;

  HadithCollection({
    required this.name,
    required this.description,
    required this.author,
    required this.totalHadiths,
    required this.language,
  });

  factory HadithCollection.fromJson(Map<String, dynamic> json) {
    return HadithCollection(
      name: json['name'] as String,
      description: json['description'] as String,
      author: json['author'] as String,
      totalHadiths: json['totalHadiths'] as int,
      language: json['language'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'author': author,
      'totalHadiths': totalHadiths,
      'language': language,
    };
  }
}

class HadithBook {
  final String name;
  final String description;
  final int totalHadiths;
  final List<String> chapters;
  final String collection;

  HadithBook({
    required this.name,
    required this.description,
    required this.totalHadiths,
    required this.chapters,
    required this.collection,
  });

  factory HadithBook.fromJson(Map<String, dynamic> json) {
    return HadithBook(
      name: json['name'] as String,
      description: json['description'] as String,
      totalHadiths: json['totalHadiths'] as int,
      chapters: (json['chapters'] as List<dynamic>).map((chapter) => chapter as String).toList(),
      collection: json['collection'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'totalHadiths': totalHadiths,
      'chapters': chapters,
      'collection': collection,
    };
  }
}
