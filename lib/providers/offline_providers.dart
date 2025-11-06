import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../models/action_queue_item.dart';
import '../models/poll.dart';
import '../models/user.dart';
import '../models/user_vote.dart';
import '../repositories/action_queue_service.dart';
import '../repositories/export_data_service.dart';
import '../repositories/mock_auth_repository.dart';
import '../repositories/mock_poll_repository.dart';
import '../repositories/mock_sync_service.dart';
import 'poll_providers.dart';

final StateProvider<bool> offlineModeProvider =
    StateProvider<bool>((Ref ref) => false);

final Provider<ActionQueueService> actionQueueServiceProvider =
    Provider<ActionQueueService>((Ref ref) {
  final Box<ActionQueueItem> queueBox = Hive.box<ActionQueueItem>(actionQueueBoxName);
  return ActionQueueService(queueBox);
});

final Provider<MockSyncService> mockSyncServiceProvider =
    Provider<MockSyncService>((Ref ref) {
  final ActionQueueService queueService = ref.watch(actionQueueServiceProvider);
  final mockPollRepository = ref.watch(mockPollRepositoryProvider);
  return MockSyncService(queueService, mockPollRepository);
});

final Provider<ExportDataService> exportDataServiceProvider =
    Provider<ExportDataService>((Ref ref) {
  final Box<Poll> pollsBox = Hive.box<Poll>(pollsBoxName);
  final Box<UserVote> votesBox = Hive.box<UserVote>(votesBoxName);
  final Box<User> usersBox = Hive.box<User>(usersAuthBoxName);
  return ExportDataService(pollsBox, votesBox, usersBox);
});
