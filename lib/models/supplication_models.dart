class Supplication {
  final String id;
  final String title;
  final String arabicText;
  final String englishText;
  final String transliteration;
  final String category;
  final String context;
  final String audioUrl;
  final int repetition;
  final List<String> benefits;
  final String reference;

  Supplication({
    required this.id,
    required this.title,
    required this.arabicText,
    required this.englishText,
    required this.transliteration,
    required this.category,
    required this.context,
    required this.audioUrl,
    required this.repetition,
    required this.benefits,
    required this.reference,
  });

  factory Supplication.fromJson(Map<String, dynamic> json) {
    return Supplication(
      id: json['id'] as String,
      title: json['title'] as String,
      arabicText: json['arabicText'] as String,
      englishText: json['englishText'] as String,
      transliteration: json['transliteration'] as String,
      category: json['category'] as String,
      context: json['context'] as String,
      audioUrl: json['audioUrl'] as String,
      repetition: json['repetition'] as int,
      benefits: (json['benefits'] as List<dynamic>).map((benefit) => benefit as String).toList(),
      reference: json['reference'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'arabicText': arabicText,
      'englishText': englishText,
      'transliteration': transliteration,
      'category': category,
      'context': context,
      'audioUrl': audioUrl,
      'repetition': repetition,
      'benefits': benefits,
      'reference': reference,
    };
  }
}

class SupplicationCategory {
  final String name;
  final String description;
  final String icon;
  final int count;

  SupplicationCategory({
    required this.name,
    required this.description,
    required this.icon,
    required this.count,
  });

  factory SupplicationCategory.fromJson(Map<String, dynamic> json) {
    return SupplicationCategory(
      name: json['name'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      count: json['count'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'icon': icon,
      'count': count,
    };
  }
}
