class Reciter {
  final String id;
  final String name;
  final String nameArabic;
  final String country;
  final String style; // 'murattal', 'muallim', 'tajweed'
  final String quality; // 'high', 'medium', 'low'
  final String language;
  final String description;
  final String imageUrl;
  final bool isPopular;
  final bool isRecommended;
  final int totalRecitations;
  final double rating;
  final List<String> availableFormats; // 'mp3', 'ogg', 'wav'
  final Map<String, String> audioUrls; // format -> url

  Reciter({
    required this.id,
    required this.name,
    required this.nameArabic,
    required this.country,
    required this.style,
    required this.quality,
    required this.language,
    required this.description,
    required this.imageUrl,
    required this.isPopular,
    required this.isRecommended,
    required this.totalRecitations,
    required this.rating,
    required this.availableFormats,
    required this.audioUrls,
  });

  factory Reciter.fromJson(Map<String, dynamic> json) {
    return Reciter(
      id: json['id'] as String,
      name: json['name'] as String,
      nameArabic: json['nameArabic'] as String,
      country: json['country'] as String,
      style: json['style'] as String,
      quality: json['quality'] as String,
      language: json['language'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      isPopular: json['isPopular'] as bool,
      isRecommended: json['isRecommended'] as bool,
      totalRecitations: json['totalRecitations'] as int,
      rating: (json['rating'] as num).toDouble(),
      availableFormats: (json['availableFormats'] as List<dynamic>).map((format) => format as String).toList(),
      audioUrls: Map<String, String>.from(json['audioUrls'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameArabic': nameArabic,
      'country': country,
      'style': style,
      'quality': quality,
      'language': language,
      'description': description,
      'imageUrl': imageUrl,
      'isPopular': isPopular,
      'isRecommended': isRecommended,
      'totalRecitations': totalRecitations,
      'rating': rating,
      'availableFormats': availableFormats,
      'audioUrls': audioUrls,
    };
  }
}

class AudioTrack {
  final String id;
  final String title;
  final String reciterId;
  final String surahNumber;
  final String ayahNumber;
  final String audioUrl;
  final String format; // 'mp3', 'ogg', 'wav'
  final int duration; // in seconds
  final int fileSize; // in bytes
  final String quality; // 'high', 'medium', 'low'
  final bool isDownloaded;
  final String? localPath;
  final DateTime createdAt;
  final DateTime? downloadedAt;
  final int playCount;
  final double rating;
  final List<String> tags;

  AudioTrack({
    required this.id,
    required this.title,
    required this.reciterId,
    required this.surahNumber,
    required this.ayahNumber,
    required this.audioUrl,
    required this.format,
    required this.duration,
    required this.fileSize,
    required this.quality,
    required this.isDownloaded,
    this.localPath,
    required this.createdAt,
    this.downloadedAt,
    required this.playCount,
    required this.rating,
    required this.tags,
  });

  factory AudioTrack.fromJson(Map<String, dynamic> json) {
    return AudioTrack(
      id: json['id'] as String,
      title: json['title'] as String,
      reciterId: json['reciterId'] as String,
      surahNumber: json['surahNumber'] as String,
      ayahNumber: json['ayahNumber'] as String,
      audioUrl: json['audioUrl'] as String,
      format: json['format'] as String,
      duration: json['duration'] as int,
      fileSize: json['fileSize'] as int,
      quality: json['quality'] as String,
      isDownloaded: json['isDownloaded'] as bool,
      localPath: json['localPath'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      downloadedAt: json['downloadedAt'] != null ? DateTime.parse(json['downloadedAt'] as String) : null,
      playCount: json['playCount'] as int,
      rating: (json['rating'] as num).toDouble(),
      tags: (json['tags'] as List<dynamic>).map((tag) => tag as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'reciterId': reciterId,
      'surahNumber': surahNumber,
      'ayahNumber': ayahNumber,
      'audioUrl': audioUrl,
      'format': format,
      'duration': duration,
      'fileSize': fileSize,
      'quality': quality,
      'isDownloaded': isDownloaded,
      'localPath': localPath,
      'createdAt': createdAt.toIso8601String(),
      'downloadedAt': downloadedAt?.toIso8601String(),
      'playCount': playCount,
      'rating': rating,
      'tags': tags,
    };
  }
}

class Playlist {
  final String id;
  final String name;
  final String description;
  final String type; // 'quran', 'hadith', 'supplication', 'custom'
  final List<String> trackIds;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPublic;
  final String? coverImageUrl;
  final int playCount;
  final double rating;
  final List<String> tags;
  final String? ownerId;

  Playlist({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.trackIds,
    required this.createdAt,
    required this.updatedAt,
    required this.isPublic,
    this.coverImageUrl,
    required this.playCount,
    required this.rating,
    required this.tags,
    this.ownerId,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      trackIds: (json['trackIds'] as List<dynamic>).map((id) => id as String).toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isPublic: json['isPublic'] as bool,
      coverImageUrl: json['coverImageUrl'] as String?,
      playCount: json['playCount'] as int,
      rating: (json['rating'] as num).toDouble(),
      tags: (json['tags'] as List<dynamic>).map((tag) => tag as String).toList(),
      ownerId: json['ownerId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type,
      'trackIds': trackIds,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isPublic': isPublic,
      'coverImageUrl': coverImageUrl,
      'playCount': playCount,
      'rating': rating,
      'tags': tags,
      'ownerId': ownerId,
    };
  }
}

class AudioPlaybackState {
  final String currentTrackId;
  final String currentPlaylistId;
  final bool isPlaying;
  final bool isPaused;
  final bool isShuffled;
  final bool isRepeating;
  final String repeatMode; // 'none', 'one', 'all'
  final double currentPosition; // in seconds
  final double duration; // in seconds
  final double volume;
  final double playbackSpeed;
  final String quality;
  final DateTime lastPlayedAt;
  final List<String> queue;
  final int currentIndex;

  AudioPlaybackState({
    required this.currentTrackId,
    required this.currentPlaylistId,
    required this.isPlaying,
    required this.isPaused,
    required this.isShuffled,
    required this.isRepeating,
    required this.repeatMode,
    required this.currentPosition,
    required this.duration,
    required this.volume,
    required this.playbackSpeed,
    required this.quality,
    required this.lastPlayedAt,
    required this.queue,
    required this.currentIndex,
  });

  factory AudioPlaybackState.fromJson(Map<String, dynamic> json) {
    return AudioPlaybackState(
      currentTrackId: json['currentTrackId'] as String,
      currentPlaylistId: json['currentPlaylistId'] as String,
      isPlaying: json['isPlaying'] as bool,
      isPaused: json['isPaused'] as bool,
      isShuffled: json['isShuffled'] as bool,
      isRepeating: json['isRepeating'] as bool,
      repeatMode: json['repeatMode'] as String,
      currentPosition: (json['currentPosition'] as num).toDouble(),
      duration: (json['duration'] as num).toDouble(),
      volume: (json['volume'] as num).toDouble(),
      playbackSpeed: (json['playbackSpeed'] as num).toDouble(),
      quality: json['quality'] as String,
      lastPlayedAt: DateTime.parse(json['lastPlayedAt'] as String),
      queue: (json['queue'] as List<dynamic>).map((id) => id as String).toList(),
      currentIndex: json['currentIndex'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentTrackId': currentTrackId,
      'currentPlaylistId': currentPlaylistId,
      'isPlaying': isPlaying,
      'isPaused': isPaused,
      'isShuffled': isShuffled,
      'isRepeating': isRepeating,
      'repeatMode': repeatMode,
      'currentPosition': currentPosition,
      'duration': duration,
      'volume': volume,
      'playbackSpeed': playbackSpeed,
      'quality': quality,
      'lastPlayedAt': lastPlayedAt.toIso8601String(),
      'queue': queue,
      'currentIndex': currentIndex,
    };
  }
}

class DownloadProgress {
  final String trackId;
  final String fileName;
  final int downloadedBytes;
  final int totalBytes;
  final double progress; // 0.0 to 1.0
  final String status; // 'downloading', 'completed', 'failed', 'paused'
  final DateTime startedAt;
  final DateTime? completedAt;
  final String? errorMessage;
  final String? localPath;

  DownloadProgress({
    required this.trackId,
    required this.fileName,
    required this.downloadedBytes,
    required this.totalBytes,
    required this.progress,
    required this.status,
    required this.startedAt,
    this.completedAt,
    this.errorMessage,
    this.localPath,
  });

  factory DownloadProgress.fromJson(Map<String, dynamic> json) {
    return DownloadProgress(
      trackId: json['trackId'] as String,
      fileName: json['fileName'] as String,
      downloadedBytes: json['downloadedBytes'] as int,
      totalBytes: json['totalBytes'] as int,
      progress: (json['progress'] as num).toDouble(),
      status: json['status'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt'] as String) : null,
      errorMessage: json['errorMessage'] as String?,
      localPath: json['localPath'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'trackId': trackId,
      'fileName': fileName,
      'downloadedBytes': downloadedBytes,
      'totalBytes': totalBytes,
      'progress': progress,
      'status': status,
      'startedAt': startedAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'errorMessage': errorMessage,
      'localPath': localPath,
    };
  }
}
