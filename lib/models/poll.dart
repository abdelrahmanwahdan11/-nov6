import 'package:hive/hive.dart';

import 'poll_option.dart';

part 'poll.g.dart';

@HiveType(typeId: 0)
class Poll extends HiveObject {
  Poll({
    required this.id,
    required this.question,
    required this.options,
    required this.authorId,
    required this.endDate,
  });

  @HiveField(0)
  String id;

  @HiveField(1)
  String question;

  @HiveField(2)
  List<PollOption> options;

  @HiveField(3)
  String authorId;

  @HiveField(4)
  DateTime endDate;
}
