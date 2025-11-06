import 'package:hive/hive.dart';

part 'poll_option.g.dart';

@HiveType(typeId: 1)
class PollOption extends HiveObject {
  PollOption({
    required this.id,
    required this.text,
    this.voteCount = 0,
  });

  @HiveField(0)
  String id;

  @HiveField(1)
  String text;

  @HiveField(2)
  int voteCount;
}
