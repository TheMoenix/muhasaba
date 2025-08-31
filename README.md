# Muhasaba - Daily Action Tracker

A Flutter application for tracking daily good and bad actions with optional notes and numeric scores. The name "Muhasaba" comes from Arabic meaning "self-accountability" or "introspection".

## Features

- **Daily Action Tracking**: Record positive and negative actions throughout your day
- **Scoring System**: Assign numeric values to actions for quantified self-improvement
- **Notes Support**: Add context and details to your entries
- **Daily Summary**: View net scores and progress at a glance
- **Dark/Light Themes**: Modern UI with adaptive theming
- **Local Storage**: All data stored securely on device using Hive database
- **Cross-Platform**: Runs on Android, iOS, Web, Windows, macOS, and Linux

## Getting Started

### Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK
- A code editor (VS Code, Android Studio, etc.)

### Installation

1. Clone the repository:

   ```bash
   git clone <repository-url>
   cd muhasaba
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Architecture

The app follows clean architecture principles with:

- **Riverpod** for state management
- **Hive** for local data persistence
- **Material 3** design system
- **Responsive UI** that adapts to different screen sizes

## Project Structure

```
lib/
├── core/           # Theme and shared utilities
├── data/           # Data models and repositories
├── features/       # Feature-specific code
│   ├── home/       # Main tracking interface
│   └── settings/   # App configuration
└── main.dart       # App entry point
```

## Contributing

This is a personal productivity app. Feel free to fork and customize for your own needs.

## License

This project is open source and available under the [MIT License](LICENSE).
