import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../models/poll.dart';
import '../models/user_mock.dart';
import '../models/user_vote.dart';
import '../repositories/mock_poll_repository.dart';

final Provider<MockPollRepository> mockPollRepositoryProvider =
    Provider<MockPollRepository>((ProviderRef<MockPollRepository> ref) {
  final Box<Poll> pollsBox = Hive.box<Poll>(pollsBoxName);
  final Box<UserVote> votesBox = Hive.box<UserVote>(votesBoxName);
  final Box<UserMock> usersBox = Hive.box<UserMock>(usersBoxName);
  return MockPollRepository(pollsBox, votesBox, usersBox);
});

class PollListNotifier extends AsyncNotifier<List<Poll>> {
  @override
  Future<List<Poll>> build() {
    final MockPollRepository repository = ref.watch(mockPollRepositoryProvider);
    return repository.getPopularPolls();
  }
}

final AsyncNotifierProvider<PollListNotifier, List<Poll>> pollListProvider =
    AsyncNotifierProvider<PollListNotifier, List<Poll>>(PollListNotifier.new);

class PollDetailsNotifier extends FamilyAsyncNotifier<Poll?, String> {
  @override
  Future<Poll?> build(String pollId) {
    final MockPollRepository repository = ref.watch(mockPollRepositoryProvider);
    return repository.getPollById(pollId);
  }
}

final AsyncNotifierProviderFamily<PollDetailsNotifier, Poll?, String>
    pollDetailsProvider = AsyncNotifierProviderFamily<PollDetailsNotifier, Poll?, String>(
  PollDetailsNotifier.new,
);

final Provider<UserMock?> userProvider = Provider<UserMock?>((ref) {
  return ref.watch(mockPollRepositoryProvider).getCurrentUser();
});

final FutureProvider<List<Poll>> userPollsProvider = FutureProvider<List<Poll>>((ref) {
  return ref.watch(mockPollRepositoryProvider).getPollsByAuthor(currentUserId);
});

class UserVoteNotifier extends FamilyNotifier<UserVote?, String> {
  @override
  UserVote? build(String pollId) {
    final MockPollRepository repository = ref.watch(mockPollRepositoryProvider);
    return repository.getUserVote(pollId, currentUserId);
  }

  Future<void> refresh() async {
    final String pollId = arg;
    state = ref.read(mockPollRepositoryProvider).getUserVote(pollId, currentUserId);
  }
}

final NotifierProviderFamily<UserVoteNotifier, UserVote?, String> userVoteProvider =
    NotifierProviderFamily<UserVoteNotifier, UserVote?, String>(
  UserVoteNotifier.new,
);
