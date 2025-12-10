# 📱 Fusion News & Weather App

A comprehensive Flutter application showcasing **Clean Architecture** with local authentication, news feed, and weather forecasts. Built for senior Flutter developer assessment.

[![Flutter](https://img.shields.io/badge/Flutter-3.38.0-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.10.0-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 🎯 Features

### ✅ Completed Features

#### 🔐 Authentication (Local)
- User registration with email, password, and name
- Secure login with SHA-256 password hashing
- Session persistence across app restarts
- Logout functionality
- Form validation with localized error messages

#### 🌍 Localization
- **English** and **Arabic** support
- RTL layout for Arabic
- 80+ translated strings
- Dynamic language switching

#### 🎨 Theming
- **Material 3 Design**
- Dark and Light themes
- System theme detection
- Custom color schemes

### 🔄 In Progress

#### 📰 News Feature
- Top headlines from News API
- Search by keyword
- Filter by category (technology, business, sports, etc.)
- Infinite scroll pagination
- Pull-to-refresh
- Offline caching with SQLite
- WebView for full articles

#### 🌤️ Weather Feature
- Current weather from OpenWeather API
- Hourly and 7-day forecasts
- City search with geocoding
- Save multiple cities
- Custom temperature chart (CustomPainter)
- Offline caching

#### 🏠 Home Dashboard
- Bottom navigation
- Offline mode banner
- Profile management

## 🏗️ Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/                    # Shared utilities
│   ├── constants/          # API keys, app constants
│   ├── di/                 # Dependency injection (GetIt)
│   ├── error/              # Failures & exceptions
│   ├── helpers/            # Crypto, logging
│   ├── network/            # Connectivity checker
│   ├── services/           # Database, Dio factory
│   ├── theme/              # App themes
│   └── usecases/           # Base usecase
│
├── features/               # Feature modules
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/    # SQLite operations
│   │   │   ├── models/         # Data models
│   │   │   └── repositories/   # Repository implementation
│   │   ├── domain/
│   │   │   ├── entities/       # Business entities
│   │   │   ├── repositories/   # Repository interfaces
│   │   │   └── usecases/       # Business logic
│   │   └── presentation/
│   │       ├── cubits/         # State management
│   │       ├── pages/          # UI screens
│   │       └── widgets/        # Reusable widgets
│   ├── news/               # (In Progress)
│   └── weather/            # (In Progress)
│
└── main.dart
```

## 🛠️ Tech Stack

### State Management
- **flutter_bloc** (Cubit pattern)
- **freezed** for immutable states
- **equatable** for value equality

### Dependency Injection
- **get_it** for service locator pattern

### Local Storage
- **sqflite** for SQLite database
- **shared_preferences** for simple key-value storage

### Networking
- **dio** for HTTP requests
- **connectivity_plus** for network monitoring
- **pretty_dio_logger** for debugging

### Security
- **crypto** for SHA-256 password hashing

### UI/UX
- **flutter_screenutil** for responsive design
- **webview_flutter** for in-app browser
- **cached_network_image** for image caching
- **easy_localization** for i18n

### Code Generation
- **build_runner**
- **freezed_annotation**
- **json_serializable**

### Testing
- **mockito** for mocking
- **bloc_test** for cubit testing
- **integration_test** for E2E tests

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.38.0 or higher
- Dart SDK 3.10.0 or higher
- Android Studio / VS Code
- Android Emulator or iOS Simulator

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/hmagdyadel/fusion_news_weather_app.git
cd fusion_news_weather_app
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Generate code**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. **Run the app**
```bash
flutter run
```

## 🔑 API Keys

This project uses the following APIs:

- **News API**: `8ba0edbae9ca4a32a77a09742835ea0f`
- **OpenWeather API**: `422c09d453ede04e120d0b0b73dd53e4`

Keys are configured in `lib/core/constants/api_constants.dart`

## 📱 Screenshots

*Coming soon after UI completion*

## 🧪 Testing

### Run Unit Tests
```bash
flutter test
```

### Run Integration Tests
```bash
flutter test integration_test/
```

### Coverage Report
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## 📦 Project Status

| Feature | Status | Progress |
|---------|--------|----------|
| Core Infrastructure | ✅ Complete | 100% |
| Authentication | ✅ Complete | 100% |
| News Feature | 🔄 In Progress | 0% |
| Weather Feature | ⏳ Pending | 0% |
| Home Dashboard | ⏳ Pending | 0% |
| Testing | ⏳ Pending | 0% |
| **Overall** | **🔄 In Progress** | **25%** |

## 🎓 Learning Objectives

This project demonstrates:

✅ Clean Architecture implementation
✅ SOLID principles
✅ Dependency Injection
✅ State Management with Cubit
✅ Local database with SQLite
✅ API integration
✅ Offline-first architecture
✅ Error handling with Either pattern
✅ Localization (i18n)
✅ Responsive UI design
✅ Unit and integration testing

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Haitham Magdy**
- GitHub: [@hmagdyadel](https://github.com/hmagdyadel)

## 🙏 Acknowledgments

- [News API](https://newsapi.org/) for news data
- [OpenWeather](https://openweathermap.org/) for weather data
- Flutter community for amazing packages

---

**Last Updated**: December 10, 2025
**Version**: 1.0.0 (In Development)
