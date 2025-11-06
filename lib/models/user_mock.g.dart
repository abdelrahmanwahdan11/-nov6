// GENERATED CODE - MANUALLY WRITTEN FOR OFFLINE USE

part of 'user_mock.dart';

class UserMockAdapter extends TypeAdapter<UserMock> {
  @override
  final int typeId = 2;

  @override
  UserMock read(BinaryReader reader) {
    final int numOfFields = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return UserMock(
      id: fields[0] as String,
      name: fields[1] as String,
      avatarUrl: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserMock obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.avatarUrl);
  }
}
