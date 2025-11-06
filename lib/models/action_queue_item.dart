import 'package:hive/hive.dart';

const String actionQueueBoxName = 'action_queue_box';

class ActionQueueItem extends HiveObject {
  ActionQueueItem({
    required this.id,
    required this.actionType,
    required this.payload,
  });

  final String id;
  final String actionType;
  final Map<String, dynamic> payload;
}

class ActionQueueItemAdapter extends TypeAdapter<ActionQueueItem> {
  @override
  final int typeId = 5;

  @override
  ActionQueueItem read(BinaryReader reader) {
    final int numOfFields = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return ActionQueueItem(
      id: fields[0] as String,
      actionType: fields[1] as String,
      payload: (fields[2] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, ActionQueueItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.actionType)
      ..writeByte(2)
      ..write(obj.payload);
  }
}
