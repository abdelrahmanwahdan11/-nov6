// GENERATED CODE - MANUALLY WRITTEN FOR OFFLINE USE

part of 'user_vote.dart';

class UserVoteAdapter extends TypeAdapter<UserVote> {
  @override
  final int typeId = 3;

  @override
  UserVote read(BinaryReader reader) {
    final int numOfFields = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return UserVote(
      userId: fields[0] as String,
      pollId: fields[1] as String,
      selectedOptionId: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserVote obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.pollId)
      ..writeByte(2)
      ..write(obj.selectedOptionId);
  }
}
