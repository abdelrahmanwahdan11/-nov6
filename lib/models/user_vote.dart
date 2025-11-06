import 'package:hive/hive.dart';

part 'user_vote.g.dart';

@HiveType(typeId: 3)
class UserVote extends HiveObject {
  UserVote({
    required this.userId,
    required this.pollId,
    required this.selectedOptionId,
  });

  @HiveField(0)
  String userId;

  @HiveField(1)
  String pollId;

  @HiveField(2)
  String selectedOptionId;
}
