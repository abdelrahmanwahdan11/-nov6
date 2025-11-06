import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../models/poll.dart';
import '../models/user_mock.dart';
import '../models/user_vote.dart';
import '../repositories/mock_poll_repository.dart';
import 'app_providers.dart';

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
  final MockPollRepository repository = ref.watch(mockPollRepositoryProvider);
  final user = ref.watch(currentUserProvider);
  if (user != null) {
    return repository.getUserById(user.id) ??
        UserMock(id: user.id, name: user.name, avatarUrl: '');
  }
  return repository.getUserById(defaultAuthorId);
});

final FutureProvider<List<Poll>> userPollsProvider = FutureProvider<List<Poll>>((ref) {
  final user = ref.watch(currentUserProvider);
  final MockPollRepository repository = ref.watch(mockPollRepositoryProvider);
  if (user == null) {
    return repository.getPollsByAuthor(defaultAuthorId);
  }
  return repository.getPollsByAuthor(user.id);
});

class UserVoteNotifier extends FamilyNotifier<UserVote?, String> {
  @override
  UserVote? build(String pollId) {
    final MockPollRepository repository = ref.watch(mockPollRepositoryProvider);
    final user = ref.watch(currentUserProvider);
    if (user == null) {
      return null;
    }
    return repository.getUserVote(pollId, user.id);
  }

  Future<void> refresh() async {
    final String pollId = arg;
    final user = ref.read(currentUserProvider);
    if (user == null) {
      state = null;
      return;
    }
    state = ref
        .read(mockPollRepositoryProvider)
        .getUserVote(pollId, user.id);
  }
}

final NotifierProviderFamily<UserVoteNotifier, UserVote?, String> userVoteProvider =
    NotifierProviderFamily<UserVoteNotifier, UserVote?, String>(
  UserVoteNotifier.new,
);
