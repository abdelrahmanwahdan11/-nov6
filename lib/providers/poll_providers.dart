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

final StateProvider<String> categoryFilterProvider =
    StateProvider<String>((ref) => 'All');

final StreamProvider<List<Poll>> pollListProvider =
    StreamProvider<List<Poll>>((ref) {
  final String category = ref.watch(categoryFilterProvider);
  final MockPollRepository repository = ref.watch(mockPollRepositoryProvider);
  return repository.getPolls(category);
});

final StateProvider<String> searchQueryProvider =
    StateProvider<String>((ref) => '');

final StreamProviderFamily<List<Poll>, String> searchResultsProvider =
    StreamProvider.autoDispose.family<List<Poll>, String>((ref, query) {
  final MockPollRepository repository = ref.watch(mockPollRepositoryProvider);
  return repository.searchPolls(query);
});

final StreamProvider<List<Poll>> myPollsProvider =
    StreamProvider<List<Poll>>((ref) {
  final MockPollRepository repository = ref.watch(mockPollRepositoryProvider);
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    return Stream<List<Poll>>.value(<Poll>[]);
  }
  return repository.getPollsByAuthorStream(user.id);
});

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
