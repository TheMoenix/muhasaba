# Muhasaba - AI Agent Instructions

## CRITICAL: Laser-Focused Execution

**DO EXACTLY WHAT IS ASKED - NOTHING MORE**

- Answer only the specific question or implement only the requested feature
- DO NOT fix unrelated issues, even if they would prevent the app from running
- DO NOT refactor or "improve" code unless explicitly requested
- If you encounter blocking issues outside the scope, report them and STOP
- Ask for clarification if the request is ambiguous rather than making assumptions

## Architecture Overview

This is a Flutter app for daily action tracking using **Riverpod state management** and **Hive local storage**. The core concept is "logical days" that can start at custom times (e.g., 6 AM instead of midnight) to better track daily habits.

### Key Components

- **Data Layer**: Hive-based local storage with code generation (`entry_model.dart` + `entry_model.g.dart`)
- **State Management**: Riverpod providers in feature controllers (see `home_controller.dart`, `settings_controller.dart`)
- **Features**: Modular structure under `lib/features/` (home, settings)
- **Localization**: ARB files for English/Arabic with generated localizations

## Critical Patterns

### Logical Day System

The app's unique feature is "logical days" that don't follow midnight-to-midnight:

- Use `date_utils.DateUtils.getLogicalDayRange()` and `normalizeLogicalDay()`
- Repository methods have both `ForLogicalDate` and `ForDate` variants
- Always prefer logical date methods for new features
- Day start time is configurable in settings (default: "06:00")

### Riverpod Provider Architecture

```dart
// Always use this pattern for data access:
final myProvider = Provider.family<ReturnType, InputType>((ref, input) {
  final repository = ref.watch(repositoryProvider);
  final settings = ref.watch(settingsProvider); // reactive to settings changes
  return repository.methodWithLogicalDate(input, settings);
});
```

### Hive Data Models

- All models extend `HiveObject` with `@HiveType` annotations
- Use `part 'filename.g.dart'` for code generation
- UUID-based IDs with `const Uuid().v4()`
- Always register adapters in `hive_init.dart`

## Development Workflows

### Code Generation

```bash
# Run when changing Hive models or ARB files
flutter packages pub run build_runner build

# For development with auto-rebuild on changes
flutter packages pub run build_runner watch
```

### Testing & Running

```bash
flutter pub get          # Install dependencies
flutter analyze          # Lint checking (configured in analysis_options.yaml)
flutter test             # Unit tests
flutter run              # Development run
```

### Localization

- Edit `lib/l10n/app_en.arb` and `lib/l10n/app_ar.arb`
- Run code generation to update `AppLocalizations`
- Access via `AppLocalizations.of(context).keyName`

## Project-Specific Conventions

### File Organization

- Repository classes in `lib/data/` handle all data operations
- Feature controllers use Riverpod `StateNotifier` pattern
- Date utilities in `core/date_utils.dart` for logical day calculations
- Settings managed via `SharedPreferences` with `SettingsRepository`

### Entry System

- `DayEntry` model with `EntryType.good`/`bad`, numeric scores, optional notes
- "Quick add" entries (no notes) vs full entries with notes/custom dates
- Undo functionality specifically for last quick adds (only entries with `note == null`)
- Repository streams provide reactive UI updates via `watchEntriesForLogicalDate`
- Entries sorted by date descending (most recent first) in all repository methods

### State Dependencies

When adding new providers that depend on day start time:

```dart
final myProvider = Provider((ref) {
  final dayStartTime = ref.watch(dayStartTimeProvider); // Makes reactive
  // ... use dayStartTime in calculations
});
```

### Multi-language Support

- App supports English (LTR) and Arabic (RTL)
- Use `Directionality` and `TextDirection` awareness in custom widgets
- Locale switching updates entire app via `localeProvider`

## Integration Points

- **Hive Boxes**: Single box `entries_box` for all `DayEntry` objects
- **SharedPreferences**: Settings persistence with defaults initialization
- **Material 3**: Custom theme in `core/theme.dart` with dark/light variants
- **ProviderScope**: Root-level dependency injection for SharedPreferences
- **Main Initialization**: Async setup in `main()` - Hive, SharedPreferences, settings defaults

## Common Tasks

**Adding new entry types**: Update `EntryType` enum, regenerate Hive adapters
**New settings**: Add to `SettingsRepository`, create provider, update defaults
**Date-based features**: Always consider logical vs calendar days, use existing utilities
**New screens**: Follow feature folder pattern, create controller with Riverpod

The app emphasizes simplicity, local-first data, and flexible daily tracking patterns.
