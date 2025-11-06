// GENERATED CODE - MANUALLY WRITTEN FOR OFFLINE USE

part of 'poll_option.dart';

class PollOptionAdapter extends TypeAdapter<PollOption> {
  @override
  final int typeId = 1;

  @override
  PollOption read(BinaryReader reader) {
    final int numOfFields = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return PollOption(
      id: fields[0] as String,
      text: fields[1] as String,
      voteCount: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PollOption obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.voteCount);
  }
}
