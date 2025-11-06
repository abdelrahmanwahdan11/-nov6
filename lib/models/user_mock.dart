import 'package:hive/hive.dart';

part 'user_mock.g.dart';

@HiveType(typeId: 2)
class UserMock extends HiveObject {
  UserMock({
    required this.id,
    required this.name,
    required this.avatarUrl,
  });

  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String avatarUrl;
}
