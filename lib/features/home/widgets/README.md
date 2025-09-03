# Home Widgets

This directory contains modular, reusable widgets for the home screen. Each widget is designed to be independent and can be used separately for Android/iOS home screen widgets.

## Widgets

### 1. `ScoreTotalsWidget`

- **Purpose**: Displays Good, Net, and Bad scores in a horizontal row
- **Properties**: `goodScore`, `badScore`, `netScore`
- **Usage**: Perfect for summary displays and widget overviews

### 2. `DateAndScoresWidget`

- **Purpose**: Shows date navigation with previous/next buttons and settings access
- **Properties**: Date info, navigation callbacks
- **Usage**: Complete header for date-based apps

### 3. `ActionsListWidget`

- **Purpose**: Displays a scrollable list of actions/entries for a specific type
- **Properties**: `entries`, `type`, `showNotesInEntries`, `onEntryTap`
- **Usage**: Can be used independently to show either good or bad actions

### 4. `AddActionWidget`

- **Purpose**: Text input with add/remove buttons using press-and-hold functionality
- **Properties**: TextController and various callbacks
- **Usage**: Complete input solution for adding entries

### 5. `PressAndHoldButton`

- **Purpose**: Interactive button with quick tap and press-and-hold features
- **Properties**: `type`, `icon`, `color`, callbacks
- **Usage**: Reusable for any increment/decrement functionality

### 6. `FullHomePageWidget`

- **Purpose**: Complete home page that combines all components
- **Properties**: All data and callbacks needed for the full experience
- **Usage**: Drop-in replacement for the original HomePage UI

## Design Principles

- **Modular**: Each widget can be used independently
- **Responsive**: Layouts adapt to different screen sizes
- **Reusable**: Perfect for Android/iOS home screen widgets
- **Clean**: Follows Flutter best practices
- **Theming**: Respects app theme and uses consistent styling

## Home Screen Widget Preparation

These widgets are designed with home screen widgets in mind:

- **ScoreTotalsWidget**: Great for small summary widgets
- **ActionsListWidget**: Perfect for showing recent actions in a medium widget
- **DateAndScoresWidget**: Ideal for navigation in larger widgets

Each widget accepts data via props and doesn't manage its own state, making them perfect for static displays or controlled environments like home screen widgets.

## Usage Example

```dart
import '../widgets/home/home_widgets.dart';

// Use individual widgets
ScoreTotalsWidget(
  goodScore: 10,
  badScore: 3,
  netScore: 7,
)

// Or use the complete home page
FullHomePageWidget(
  selectedDay: DateTime.now(),
  currentLogicalDay: DateTime.now(),
  goodEntries: goodEntries,
  badEntries: badEntries,
  totals: (good: 10, bad: 3, net: 7),
  showNotesInEntries: true,
  textController: textController,
  // ... all the callbacks
)
```
