// GENERATED CODE - MANUALLY WRITTEN FOR OFFLINE USE

part of 'poll.dart';

class PollAdapter extends TypeAdapter<Poll> {
  @override
  final int typeId = 0;

  @override
  Poll read(BinaryReader reader) {
    final int numOfFields = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return Poll(
      id: fields[0] as String,
      question: fields[1] as String,
      options: (fields[2] as List).cast<PollOption>(),
      authorId: fields[3] as String,
      endDate: fields[4] as DateTime,
      category: (fields[5] as String?) ?? 'General',
    );
  }

  @override
  void write(BinaryWriter writer, Poll obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.question)
      ..writeByte(2)
      ..write(obj.options)
      ..writeByte(3)
      ..write(obj.authorId)
      ..writeByte(4)
      ..write(obj.endDate)
      ..writeByte(5)
      ..write(obj.category);
  }
}
