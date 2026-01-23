import 'package:hive/hive.dart';
import '../models/task.dart';

class ReminderStateAdapter extends TypeAdapter<ReminderState> {
  @override
  final typeId = 101; // Unique type ID

  @override
  ReminderState read(BinaryReader reader) {
    return ReminderState.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, ReminderState obj) {
    writer.writeByte(obj.index);
  }
}
