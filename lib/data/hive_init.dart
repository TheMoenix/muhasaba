import 'package:hive_flutter/hive_flutter.dart';
import '../data/entry_model.dart';

class HiveInit {
  static const String entriesBoxName = 'entries_box';

  static Future<void> initialize() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(EntryTypeAdapter());
    Hive.registerAdapter(DayEntryAdapter());

    // Open boxes
    await Hive.openBox<DayEntry>(entriesBoxName);
  }

  static Future<void> close() async {
    await Hive.close();
  }
}
