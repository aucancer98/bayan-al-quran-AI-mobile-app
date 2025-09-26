class Bookmark {
  final String id;
  final int surahNumber;
  final int ayahNumber;
  final String surahName;
  final String ayahText;
  final DateTime createdAt;
  final String? note;
  final List<String> tags;
  final String type; // 'ayah', 'word', 'hadith', 'supplication'

  Bookmark({
    required this.id,
    required this.surahNumber,
    required this.ayahNumber,
    required this.surahName,
    required this.ayahText,
    required this.createdAt,
    this.note,
    required this.tags,
    required this.type,
  });

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      id: json['id'] as String,
      surahNumber: json['surahNumber'] as int,
      ayahNumber: json['ayahNumber'] as int,
      surahName: json['surahName'] as String,
      ayahText: json['ayahText'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      note: json['note'] as String?,
      tags: (json['tags'] as List<dynamic>).map((tag) => tag as String).toList(),
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'surahNumber': surahNumber,
      'ayahNumber': ayahNumber,
      'surahName': surahName,
      'ayahText': ayahText,
      'createdAt': createdAt.toIso8601String(),
      'note': note,
      'tags': tags,
      'type': type,
    };
  }
}

class Note {
  final String id;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String type; // 'ayah', 'word', 'hadith', 'supplication', 'general'
  final String? referenceId; // ID of the referenced item
  final String? referenceType; // Type of the referenced item
  final List<String> tags;
  final bool isPrivate;

  Note({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.type,
    this.referenceId,
    this.referenceType,
    required this.tags,
    required this.isPrivate,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      type: json['type'] as String,
      referenceId: json['referenceId'] as String?,
      referenceType: json['referenceType'] as String?,
      tags: (json['tags'] as List<dynamic>).map((tag) => tag as String).toList(),
      isPrivate: json['isPrivate'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'type': type,
      'referenceId': referenceId,
      'referenceType': referenceType,
      'tags': tags,
      'isPrivate': isPrivate,
    };
  }
}

class StudySession {
  final String id;
  final String title;
  final DateTime startTime;
  final DateTime? endTime;
  final Duration duration;
  final String type; // 'quran', 'hadith', 'supplication', 'general'
  final List<String> itemsStudied; // IDs of items studied
  final String? notes;
  final int wordsLearned;
  final List<String> bookmarksCreated;
  final List<String> notesCreated;

  StudySession({
    required this.id,
    required this.title,
    required this.startTime,
    this.endTime,
    required this.duration,
    required this.type,
    required this.itemsStudied,
    this.notes,
    required this.wordsLearned,
    required this.bookmarksCreated,
    required this.notesCreated,
  });

  factory StudySession.fromJson(Map<String, dynamic> json) {
    return StudySession(
      id: json['id'] as String,
      title: json['title'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime'] as String) : null,
      duration: Duration(milliseconds: json['duration'] as int),
      type: json['type'] as String,
      itemsStudied: (json['itemsStudied'] as List<dynamic>).map((item) => item as String).toList(),
      notes: json['notes'] as String?,
      wordsLearned: json['wordsLearned'] as int,
      bookmarksCreated: (json['bookmarksCreated'] as List<dynamic>).map((bookmark) => bookmark as String).toList(),
      notesCreated: (json['notesCreated'] as List<dynamic>).map((note) => note as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'duration': duration.inMilliseconds,
      'type': type,
      'itemsStudied': itemsStudied,
      'notes': notes,
      'wordsLearned': wordsLearned,
      'bookmarksCreated': bookmarksCreated,
      'notesCreated': notesCreated,
    };
  }
}

class Progress {
  final String id;
  final String userId;
  final String type; // 'quran', 'hadith', 'supplication', 'general'
  final int totalItems;
  final int completedItems;
  final int bookmarksCount;
  final int notesCount;
  final Duration totalStudyTime;
  final DateTime lastActivity;
  final Map<String, int> weeklyProgress; // Week -> count
  final Map<String, int> monthlyProgress; // Month -> count

  Progress({
    required this.id,
    required this.userId,
    required this.type,
    required this.totalItems,
    required this.completedItems,
    required this.bookmarksCount,
    required this.notesCount,
    required this.totalStudyTime,
    required this.lastActivity,
    required this.weeklyProgress,
    required this.monthlyProgress,
  });

  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: json['type'] as String,
      totalItems: json['totalItems'] as int,
      completedItems: json['completedItems'] as int,
      bookmarksCount: json['bookmarksCount'] as int,
      notesCount: json['notesCount'] as int,
      totalStudyTime: Duration(milliseconds: json['totalStudyTime'] as int),
      lastActivity: DateTime.parse(json['lastActivity'] as String),
      weeklyProgress: Map<String, int>.from(json['weeklyProgress'] as Map),
      monthlyProgress: Map<String, int>.from(json['monthlyProgress'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'totalItems': totalItems,
      'completedItems': completedItems,
      'bookmarksCount': bookmarksCount,
      'notesCount': notesCount,
      'totalStudyTime': totalStudyTime.inMilliseconds,
      'lastActivity': lastActivity.toIso8601String(),
      'weeklyProgress': weeklyProgress,
      'monthlyProgress': monthlyProgress,
    };
  }

  double get completionPercentage {
    if (totalItems == 0) return 0.0;
    return (completedItems / totalItems) * 100;
  }
}
