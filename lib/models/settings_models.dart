class AppSettings {
  final String language;
  final String theme; // 'light', 'dark', 'system'
  final bool useDynamicColors;
  final String primaryColor;
  final String secondaryColor;
  final String tertiaryColor;
  final double fontSize;
  final String fontFamily;
  final bool rtlSupport;
  final bool hapticFeedback;
  final bool soundEffects;
  final String dateFormat;
  final String timeFormat;
  final bool notificationsEnabled;
  final bool autoUpdate;
  final bool offlineMode;
  final String defaultTranslation;
  final String defaultTafsir;
  final String defaultReciter;
  final bool showTransliteration;
  final bool showWordMeaning;
  final bool showRootWords;
  final bool showContextualMeaning;
  final bool enableBookmarks;
  final bool enableNotes;
  final bool enableStudySessions;
  final bool enableProgressTracking;

  AppSettings({
    required this.language,
    required this.theme,
    required this.useDynamicColors,
    required this.primaryColor,
    required this.secondaryColor,
    required this.tertiaryColor,
    required this.fontSize,
    required this.fontFamily,
    required this.rtlSupport,
    required this.hapticFeedback,
    required this.soundEffects,
    required this.dateFormat,
    required this.timeFormat,
    required this.notificationsEnabled,
    required this.autoUpdate,
    required this.offlineMode,
    required this.defaultTranslation,
    required this.defaultTafsir,
    required this.defaultReciter,
    required this.showTransliteration,
    required this.showWordMeaning,
    required this.showRootWords,
    required this.showContextualMeaning,
    required this.enableBookmarks,
    required this.enableNotes,
    required this.enableStudySessions,
    required this.enableProgressTracking,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      language: json['language'] as String,
      theme: json['theme'] as String,
      useDynamicColors: json['useDynamicColors'] as bool,
      primaryColor: json['primaryColor'] as String,
      secondaryColor: json['secondaryColor'] as String,
      tertiaryColor: json['tertiaryColor'] as String,
      fontSize: (json['fontSize'] as num).toDouble(),
      fontFamily: json['fontFamily'] as String,
      rtlSupport: json['rtlSupport'] as bool,
      hapticFeedback: json['hapticFeedback'] as bool,
      soundEffects: json['soundEffects'] as bool,
      dateFormat: json['dateFormat'] as String,
      timeFormat: json['timeFormat'] as String,
      notificationsEnabled: json['notificationsEnabled'] as bool,
      autoUpdate: json['autoUpdate'] as bool,
      offlineMode: json['offlineMode'] as bool,
      defaultTranslation: json['defaultTranslation'] as String,
      defaultTafsir: json['defaultTafsir'] as String,
      defaultReciter: json['defaultReciter'] as String,
      showTransliteration: json['showTransliteration'] as bool,
      showWordMeaning: json['showWordMeaning'] as bool,
      showRootWords: json['showRootWords'] as bool,
      showContextualMeaning: json['showContextualMeaning'] as bool,
      enableBookmarks: json['enableBookmarks'] as bool,
      enableNotes: json['enableNotes'] as bool,
      enableStudySessions: json['enableStudySessions'] as bool,
      enableProgressTracking: json['enableProgressTracking'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language': language,
      'theme': theme,
      'useDynamicColors': useDynamicColors,
      'primaryColor': primaryColor,
      'secondaryColor': secondaryColor,
      'tertiaryColor': tertiaryColor,
      'fontSize': fontSize,
      'fontFamily': fontFamily,
      'rtlSupport': rtlSupport,
      'hapticFeedback': hapticFeedback,
      'soundEffects': soundEffects,
      'dateFormat': dateFormat,
      'timeFormat': timeFormat,
      'notificationsEnabled': notificationsEnabled,
      'autoUpdate': autoUpdate,
      'offlineMode': offlineMode,
      'defaultTranslation': defaultTranslation,
      'defaultTafsir': defaultTafsir,
      'defaultReciter': defaultReciter,
      'showTransliteration': showTransliteration,
      'showWordMeaning': showWordMeaning,
      'showRootWords': showRootWords,
      'showContextualMeaning': showContextualMeaning,
      'enableBookmarks': enableBookmarks,
      'enableNotes': enableNotes,
      'enableStudySessions': enableStudySessions,
      'enableProgressTracking': enableProgressTracking,
    };
  }
}

class QuranSettings {
  final String defaultTranslation;
  final String defaultTafsir;
  final String defaultReciter;
  final bool showTransliteration;
  final bool showWordMeaning;
  final bool showRootWords;
  final bool showContextualMeaning;
  final bool showGrammarInfo;
  final bool showRelatedWords;
  final bool enableWordClicking;
  final bool autoPlayAudio;
  final double audioVolume;
  final bool repeatMode;
  final int repeatCount;
  final String textDirection; // 'rtl', 'ltr'
  final String textAlignment; // 'right', 'left', 'center'
  final double lineSpacing;
  final double wordSpacing;
  final bool showVerseNumbers;
  final bool showSurahNames;
  final bool showBismillah;
  final bool enableBookmarks;
  final bool enableNotes;
  final bool enableSharing;

  QuranSettings({
    required this.defaultTranslation,
    required this.defaultTafsir,
    required this.defaultReciter,
    required this.showTransliteration,
    required this.showWordMeaning,
    required this.showRootWords,
    required this.showContextualMeaning,
    required this.showGrammarInfo,
    required this.showRelatedWords,
    required this.enableWordClicking,
    required this.autoPlayAudio,
    required this.audioVolume,
    required this.repeatMode,
    required this.repeatCount,
    required this.textDirection,
    required this.textAlignment,
    required this.lineSpacing,
    required this.wordSpacing,
    required this.showVerseNumbers,
    required this.showSurahNames,
    required this.showBismillah,
    required this.enableBookmarks,
    required this.enableNotes,
    required this.enableSharing,
  });

  factory QuranSettings.fromJson(Map<String, dynamic> json) {
    return QuranSettings(
      defaultTranslation: json['defaultTranslation'] as String,
      defaultTafsir: json['defaultTafsir'] as String,
      defaultReciter: json['defaultReciter'] as String,
      showTransliteration: json['showTransliteration'] as bool,
      showWordMeaning: json['showWordMeaning'] as bool,
      showRootWords: json['showRootWords'] as bool,
      showContextualMeaning: json['showContextualMeaning'] as bool,
      showGrammarInfo: json['showGrammarInfo'] as bool,
      showRelatedWords: json['showRelatedWords'] as bool,
      enableWordClicking: json['enableWordClicking'] as bool,
      autoPlayAudio: json['autoPlayAudio'] as bool,
      audioVolume: (json['audioVolume'] as num).toDouble(),
      repeatMode: json['repeatMode'] as bool,
      repeatCount: json['repeatCount'] as int,
      textDirection: json['textDirection'] as String,
      textAlignment: json['textAlignment'] as String,
      lineSpacing: (json['lineSpacing'] as num).toDouble(),
      wordSpacing: (json['wordSpacing'] as num).toDouble(),
      showVerseNumbers: json['showVerseNumbers'] as bool,
      showSurahNames: json['showSurahNames'] as bool,
      showBismillah: json['showBismillah'] as bool,
      enableBookmarks: json['enableBookmarks'] as bool,
      enableNotes: json['enableNotes'] as bool,
      enableSharing: json['enableSharing'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'defaultTranslation': defaultTranslation,
      'defaultTafsir': defaultTafsir,
      'defaultReciter': defaultReciter,
      'showTransliteration': showTransliteration,
      'showWordMeaning': showWordMeaning,
      'showRootWords': showRootWords,
      'showContextualMeaning': showContextualMeaning,
      'showGrammarInfo': showGrammarInfo,
      'showRelatedWords': showRelatedWords,
      'enableWordClicking': enableWordClicking,
      'autoPlayAudio': autoPlayAudio,
      'audioVolume': audioVolume,
      'repeatMode': repeatMode,
      'repeatCount': repeatCount,
      'textDirection': textDirection,
      'textAlignment': textAlignment,
      'lineSpacing': lineSpacing,
      'wordSpacing': wordSpacing,
      'showVerseNumbers': showVerseNumbers,
      'showSurahNames': showSurahNames,
      'showBismillah': showBismillah,
      'enableBookmarks': enableBookmarks,
      'enableNotes': enableNotes,
      'enableSharing': enableSharing,
    };
  }
}

class AudioSettings {
  final String defaultReciter;
  final double volume;
  final bool autoPlay;
  final bool repeatMode;
  final int repeatCount;
  final bool downloadAudio;
  final bool highQualityAudio;
  final String audioFormat; // 'mp3', 'ogg', 'wav'
  final bool backgroundPlay;
  final bool showWaveform;
  final double playbackSpeed;
  final bool enableEqualizer;
  final Map<String, double> equalizerSettings;

  AudioSettings({
    required this.defaultReciter,
    required this.volume,
    required this.autoPlay,
    required this.repeatMode,
    required this.repeatCount,
    required this.downloadAudio,
    required this.highQualityAudio,
    required this.audioFormat,
    required this.backgroundPlay,
    required this.showWaveform,
    required this.playbackSpeed,
    required this.enableEqualizer,
    required this.equalizerSettings,
  });

  factory AudioSettings.fromJson(Map<String, dynamic> json) {
    return AudioSettings(
      defaultReciter: json['defaultReciter'] as String,
      volume: (json['volume'] as num).toDouble(),
      autoPlay: json['autoPlay'] as bool,
      repeatMode: json['repeatMode'] as bool,
      repeatCount: json['repeatCount'] as int,
      downloadAudio: json['downloadAudio'] as bool,
      highQualityAudio: json['highQualityAudio'] as bool,
      audioFormat: json['audioFormat'] as String,
      backgroundPlay: json['backgroundPlay'] as bool,
      showWaveform: json['showWaveform'] as bool,
      playbackSpeed: (json['playbackSpeed'] as num).toDouble(),
      enableEqualizer: json['enableEqualizer'] as bool,
      equalizerSettings: Map<String, double>.from(json['equalizerSettings'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'defaultReciter': defaultReciter,
      'volume': volume,
      'autoPlay': autoPlay,
      'repeatMode': repeatMode,
      'repeatCount': repeatCount,
      'downloadAudio': downloadAudio,
      'highQualityAudio': highQualityAudio,
      'audioFormat': audioFormat,
      'backgroundPlay': backgroundPlay,
      'showWaveform': showWaveform,
      'playbackSpeed': playbackSpeed,
      'enableEqualizer': enableEqualizer,
      'equalizerSettings': equalizerSettings,
    };
  }
}

class NotificationSettings {
  final bool enabled;
  final bool prayerNotifications;
  final bool reminderNotifications;
  final bool studyReminders;
  final bool updateNotifications;
  final int prayerAdvanceMinutes;
  final String reminderTime;
  final List<String> enabledPrayers;
  final bool soundEnabled;
  final String soundFile;
  final bool vibrationEnabled;
  final bool ledEnabled;
  final String ledColor;

  NotificationSettings({
    required this.enabled,
    required this.prayerNotifications,
    required this.reminderNotifications,
    required this.studyReminders,
    required this.updateNotifications,
    required this.prayerAdvanceMinutes,
    required this.reminderTime,
    required this.enabledPrayers,
    required this.soundEnabled,
    required this.soundFile,
    required this.vibrationEnabled,
    required this.ledEnabled,
    required this.ledColor,
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      enabled: json['enabled'] as bool,
      prayerNotifications: json['prayerNotifications'] as bool,
      reminderNotifications: json['reminderNotifications'] as bool,
      studyReminders: json['studyReminders'] as bool,
      updateNotifications: json['updateNotifications'] as bool,
      prayerAdvanceMinutes: json['prayerAdvanceMinutes'] as int,
      reminderTime: json['reminderTime'] as String,
      enabledPrayers: (json['enabledPrayers'] as List<dynamic>).map((prayer) => prayer as String).toList(),
      soundEnabled: json['soundEnabled'] as bool,
      soundFile: json['soundFile'] as String,
      vibrationEnabled: json['vibrationEnabled'] as bool,
      ledEnabled: json['ledEnabled'] as bool,
      ledColor: json['ledColor'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'prayerNotifications': prayerNotifications,
      'reminderNotifications': reminderNotifications,
      'studyReminders': studyReminders,
      'updateNotifications': updateNotifications,
      'prayerAdvanceMinutes': prayerAdvanceMinutes,
      'reminderTime': reminderTime,
      'enabledPrayers': enabledPrayers,
      'soundEnabled': soundEnabled,
      'soundFile': soundFile,
      'vibrationEnabled': vibrationEnabled,
      'ledEnabled': ledEnabled,
      'ledColor': ledColor,
    };
  }
}
