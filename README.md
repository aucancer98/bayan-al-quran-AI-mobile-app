# Bayan al Quran

<div align="center">

**AI-Powered Islamic Companion App**

[![Flutter](https://img.shields.io/badge/Flutter-3.35.2-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.9.0-blue.svg)](https://dart.dev)
[![Material 3](https://img.shields.io/badge/Material%20Design-3.0-green.svg)](https://m3.material.io)
[![OpenRouter AI](https://img.shields.io/badge/AI-OpenRouter-purple.svg)](https://openrouter.ai)

*"Clarity of the Quran" - A modern approach to Islamic learning and worship*

</div>

## 🌟 Overview

Bayan al Quran is a comprehensive Islamic companion mobile application that combines traditional Islamic scholarship with cutting-edge AI technology. Built with Flutter and Material 3 design principles, it provides an intuitive and powerful platform for Quranic study, prayer guidance, and Islamic learning.

## ✨ Key Features

### 🤖 AI-Powered Analysis
- **Semantic Word Analysis**: Deep AI-powered analysis of Quranic words using OpenRouter's DeepSeek R1 model
- **Comprehensive Ayah Analysis**: Multi-source analysis combining classical tafsirs, authentic ahadith, and similar verses
- **Intelligent Search**: Semantic search across Quranic text, translations, and Islamic content
- **Contextual Understanding**: AI-driven contextual meaning and theological significance

### 📖 Quran Module
- **Word-by-Word Interactivity**: Every Arabic word is clickable for detailed analysis
- **Multiple Translations**: Various authentic translations (Sahih International, Yusuf Ali, etc.)
- **Advanced Search**: Search by word, meaning, root, or semantic similarity
- **Bookmark System**: Save favorite verses and create personal collections
- **RTL Support**: Full Arabic text support with proper right-to-left layout

### 🕌 Prayer & Worship
- **Location-Based Prayer Times**: Accurate prayer schedules with GPS support
- **Qibla Compass**: Interactive compass for prayer direction
- **Prayer Notifications**: Customizable reminders for prayer times
- **Multiple Calculation Methods**: Various Islamic prayer time calculation methods

### 📚 Islamic Knowledge
- **Authentic Ahadith**: Complete collections (Sahih Bukhari, Sahih Muslim, etc.)
- **Daily Supplications**: Morning and evening adhkar with categories
- **Islamic Calendar**: Hijri dates and important Islamic events
- **Search & Filter**: Advanced search across all Islamic content

## 🛠️ Technical Stack

### Frontend
- **Framework**: Flutter 3.35.2
- **Language**: Dart 3.9.0
- **UI Framework**: Material Design 3 (strict compliance)
- **State Management**: Provider
- **Navigation**: Go Router
- **Localization**: Flutter Localizations (English, Arabic)

### Backend & AI
- **AI Service**: OpenRouter API with DeepSeek R1 model
- **Local Storage**: SQLite + Hive + SharedPreferences
- **HTTP Client**: Dio
- **Caching**: Custom cache service for AI responses
- **Location Services**: Geolocator

### Data Sources
- **Quran Text**: Tanzil.net API + local database
- **Translations**: Multiple authentic sources
- **Prayer Times**: Aladhan.com API
- **Ahadith**: Authentic hadith databases
- **Supplications**: Traditional Islamic collections

## 🚀 Getting Started

### Prerequisites
- Flutter 3.35.2 or higher
- Dart 3.9.0 or higher
- FVM (Flutter Version Manager) - recommended
- OpenRouter API key (for AI features)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/bayan-al-quran.git
   cd bayan-al-quran
   ```

2. **Install dependencies**
   ```bash
   fvm flutter pub get
   ```

3. **Configure API keys**
   ```bash
   # Add your OpenRouter API key
   echo "your_openrouter_api_key" > openrouter_api_key.txt
   ```

4. **Run the app**
   ```bash
   fvm flutter run
   ```

### Development Setup

1. **Use FVM for version management**
   ```bash
   fvm use 3.35.2
   ```

2. **Install Flutter dependencies**
   ```bash
   fvm flutter pub get
   ```

3. **Run on specific platforms**
   ```bash
   # macOS
   fvm flutter run -d macos
   
   # iOS Simulator
   fvm flutter run -d ios
   
   # Android
   fvm flutter run -d android
   ```

## 📱 Screenshots

<div align="center">
  <img src="screenshots/home_dashboard.png" alt="Home Dashboard" width="200"/>
  <img src="screenshots/quran_analysis.png" alt="Quran Analysis" width="200"/>
  <img src="screenshots/ai_analysis.png" alt="AI Analysis" width="200"/>
  <img src="screenshots/prayer_times.png" alt="Prayer Times" width="200"/>
</div>

## 🏗️ Project Structure

```
lib/
├── constants/          # App constants and theme
│   ├── app_constants.dart
│   ├── app_theme.dart
│   └── api_config.dart
├── models/            # Data models
│   ├── quran_models.dart
│   ├── ai_models.dart
│   ├── hadith_models.dart
│   └── supplication_models.dart
├── services/          # API and database services
│   ├── ai/
│   │   └── openrouter_semantic_service.dart
│   ├── ayah_analysis_service.dart
│   ├── prayer_times_service.dart
│   └── hadith_service.dart
├── screens/           # UI screens
│   ├── home/          # Dashboard
│   ├── quran/         # Quran reading and analysis
│   ├── prayer/        # Prayer times and qibla
│   ├── hadith/        # Hadith collections
│   ├── supplications/ # Duas and dhikr
│   └── settings/      # App settings
├── widgets/           # Reusable components
│   ├── comprehensive_ayah_analysis_widget.dart
│   ├── semantic_word_analysis_widget.dart
│   └── arabic_text.dart
├── utils/             # Helper functions
└── main.dart          # App entry point
```

## 🤖 AI Features Deep Dive

### Semantic Word Analysis
- **OpenRouter Integration**: Uses DeepSeek R1 model for deep semantic analysis
- **Comprehensive Analysis**: Core meaning, semantic field, linguistic analysis, Quranic usage
- **Contextual Variations**: Different meanings in different contexts
- **Theological Significance**: Religious and spiritual implications
- **Related Content**: Relevant hadiths and modern applications

### Ayah Analysis System
- **Multi-Source Tafsir**: Combines classical and modern tafsirs
- **Hadith Integration**: Relevant authentic traditions
- **Similar Ayahs**: AI-powered verse similarity detection
- **Historical Context**: Background and revelation circumstances
- **Key Themes**: Extracted themes and concepts

## 🎨 Design Principles

- **Material Design 3**: Strict compliance with Google's Material 3 guidelines
- **Adaptive Theming**: Dynamic color theming and responsive design
- **Accessibility**: High contrast, readable fonts, screen reader support
- **RTL Support**: Full Arabic text support with proper layout
- **Islamic Aesthetics**: Subtle green/gold accents for Islamic context

## 📊 Current Status

### ✅ Completed Features
- [x] Flutter project setup with FVM
- [x] Material 3 theme implementation
- [x] Home dashboard with module cards
- [x] Quran module with word-by-word analysis
- [x] AI-powered semantic analysis
- [x] Prayer times with location services
- [x] Qibla compass functionality
- [x] Ahadith collections and search
- [x] Supplications with categories
- [x] Islamic calendar
- [x] Settings and preferences
- [x] RTL support for Arabic text

### 🚧 In Progress
- [ ] Audio recitation features
- [ ] Advanced bookmarking system
- [ ] Offline capabilities optimization
- [ ] Performance improvements

### 📋 Planned Features
- [ ] Multiple reciters support
- [ ] Study sessions and progress tracking
- [ ] Social sharing features
- [ ] Advanced search filters
- [ ] Custom themes and personalization

## 🤝 Contributing

We welcome contributions! Please follow these guidelines:

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/amazing-feature`
3. **Follow code style**: Use `dart format` and follow existing patterns
4. **Test thoroughly**: Ensure all features work on both platforms
5. **Commit changes**: `git commit -m 'Add amazing feature'`
6. **Push to branch**: `git push origin feature/amazing-feature`
7. **Open a Pull Request**

### Code Style Guidelines
- Follow Flutter/Dart best practices
- Use Material 3 components and theming
- Ensure RTL support for Arabic text
- Write clean, documented code
- Test on both light and dark themes

## 📄 License

This project is for educational and personal use. Please respect Islamic guidelines and authentic sources when implementing religious content.

## 🙏 Acknowledgments

- **Material Design 3** guidelines by Google
- **Flutter team** for the excellent framework
- **OpenRouter** for AI capabilities
- **Islamic scholars and translators** for authentic content
- **Open source community** for various packages used
- **Prophet Muhammad (PBUH)** for his guidance and teachings

## 📞 Support

If you encounter any issues or have questions:

1. Check the [Issues](https://github.com/yourusername/bayan-al-quran/issues) page
2. Create a new issue with detailed description
3. Join our community discussions

## 🌟 Star History

[![Star History Chart](https://api.star-history.com/svg?repos=yourusername/bayan-al-quran&type=Date)](https://star-history.com/#yourusername/bayan-al-quran&Date)

---

<div align="center">

**Bayan al Quran** - *"Clarity of the Quran"*

*May this app help you deepen your understanding of the Quran and strengthen your faith.*

**Made with ❤️ for the Muslim community**

</div>