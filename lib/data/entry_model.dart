import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'entry_model.g.dart';

@HiveType(typeId: 0)
enum EntryType {
  @HiveField(0)
  good,
  @HiveField(1)
  bad,
}

@HiveType(typeId: 1)
class DayEntry extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late EntryType type;

  @HiveField(2)
  late int score;

  @HiveField(3)
  String? note;

  @HiveField(4)
  late DateTime date;

  DayEntry({
    String? id,
    required this.type,
    required this.score,
    this.note,
    required this.date,
  }) : id = id ?? const Uuid().v4();

  DayEntry.empty()
    : id = '',
      type = EntryType.good,
      score = 0,
      note = null,
      date = DateTime.now();

  @override
  String toString() {
    return 'DayEntry{id: $id, type: $type, score: $score, note: $note, date: $date}';
  }
}
