import 'dart:async';
import 'dart:math';

import 'package:hive/hive.dart';

import '../models/poll.dart';
import '../models/poll_option.dart';
import '../models/user_mock.dart';
import '../models/user_vote.dart';

const String pollsBoxName = 'polls_box';
const String votesBoxName = 'votes_box';
const String usersBoxName = 'users_box';
const String defaultAuthorId = 'user-neo';

class MockPollRepository {
  MockPollRepository(
    this._pollsBox,
    this._votesBox,
    this._usersBox,
  );

  final Box<Poll> _pollsBox;
  final Box<UserVote> _votesBox;
  final Box<UserMock> _usersBox;

  Future<void> seed() async {
    if (_usersBox.isEmpty) {
      await _usersBox.put(
        defaultAuthorId,
        UserMock(
          id: defaultAuthorId,
          name: 'Layla Designer',
          avatarUrl:
              'https://avatars.dicebear.com/api/initials/LD.svg',
        ),
      );
    }

    if (_pollsBox.isNotEmpty) {
      return;
    }

    final DateTime now = DateTime.now();
    final List<Poll> defaults = <Poll>[
      Poll(
        id: 'poll-1',
        question: 'Which brutalist accent should we add next?',
        options: <PollOption>[
          PollOption(id: 'o-1', text: 'Hot pink gradients', voteCount: 34),
          PollOption(id: 'o-2', text: 'Mustard edge frames', voteCount: 28),
          PollOption(id: 'o-3', text: 'Oversized typography', voteCount: 19),
        ],
        authorId: defaultAuthorId,
        endDate: now.add(const Duration(hours: 6)),
        category: 'Tech',
      ),
      Poll(
        id: 'poll-2',
        question: 'Pick the soundtrack for the next product reveal.',
        options: <PollOption>[
          PollOption(id: 'o-4', text: 'Analog synthwave', voteCount: 12),
          PollOption(id: 'o-5', text: 'Lo-fi brutal beats', voteCount: 15),
          PollOption(id: 'o-6', text: 'Future garage', voteCount: 8),
        ],
        authorId: defaultAuthorId,
        endDate: now.add(const Duration(hours: 12)),
        category: 'Fun',
      ),
    ];

    for (final Poll poll in defaults) {
      await _pollsBox.put(poll.id, poll);
    }
  }

  Future<List<Poll>> getPopularPolls() async {
    return _filterByCategory('All');
  }

  Stream<List<Poll>> getPolls(String categoryFilter) async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield _filterByCategory(categoryFilter);
    yield* _pollsBox.watch().map((_) => _filterByCategory(categoryFilter));
  }

  Stream<List<Poll>> getPollsByAuthorStream(String authorId) async* {
    yield _pollsByAuthor(authorId);
    yield* _pollsBox.watch().map((_) => _pollsByAuthor(authorId));
  }

  Future<List<Poll>> getPollsByAuthor(String authorId) async {
    return _pollsByAuthor(authorId);
  }

  Stream<List<Poll>> searchPolls(String query) async* {
    final String normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      yield <Poll>[];
      return;
    }
    await Future<void>.delayed(const Duration(milliseconds: 300));
    yield _searchPolls(normalized);
    yield* _pollsBox.watch().map((_) => _searchPolls(normalized));
  }

  UserMock? getUserById(String id) {
    return _usersBox.get(id);
  }

  Future<void> ensureUserMock({
    required String id,
    required String name,
  }) async {
    if (_usersBox.containsKey(id)) {
      return;
    }
    final String trimmed = name.trim().isEmpty ? 'Poll User' : name.trim();
    final String condensed = trimmed.replaceAll(RegExp(r'\s+'), '');
    final int take = condensed.isEmpty
        ? 3
        : condensed.length < 3
            ? condensed.length
            : 3;
    final String initials =
        condensed.isEmpty ? 'PollUser' : condensed.substring(0, take);
    await _usersBox.put(
      id,
      UserMock(
        id: id,
        name: trimmed,
        avatarUrl:
            'https://avatars.dicebear.com/api/initials/$initials.svg',
      ),
    );
  }

  Future<Poll?> getPollById(String id) {
    return Future<Poll?>.value(_pollsBox.get(id));
  }

  Future<Poll> createPoll({
    required String question,
    required List<String> optionTexts,
    required Duration duration,
    required String authorId,
    required String authorName,
    required String category,
  }) async {
    final String pollId = 'poll-${DateTime.now().millisecondsSinceEpoch}';
    final DateTime endDate = DateTime.now().add(duration);
    final Random random = Random();
    final List<PollOption> options = optionTexts
        .where((String text) => text.trim().isNotEmpty)
        .map(
          (String text) => PollOption(
            id: '${pollId}_${text.hashCode}_${random.nextInt(999)}',
            text: text.trim(),
          ),
        )
        .toList();

    final Poll poll = Poll(
      id: pollId,
      question: question.trim(),
      options: options,
      authorId: authorId,
      endDate: endDate,
      category: category,
    );

    await ensureUserMock(id: authorId, name: authorName);
    await _pollsBox.put(pollId, poll);
    return poll;
  }

  UserVote? getUserVote(String pollId, String userId) {
    try {
      return _votesBox.values
          .firstWhere((UserVote vote) =>
              vote.pollId == pollId && vote.userId == userId);
    } catch (_) {
      return null;
    }
  }

  Future<void> addVote({
    required String pollId,
    required String optionId,
    required String userId,
  }) async {
    final Poll? poll = await getPollById(pollId);
    if (poll == null) {
      throw StateError('Poll not found');
    }

    final UserVote? existingVote = getUserVote(pollId, userId);
    if (existingVote != null) {
      return;
    }

    final PollOption selected = poll.options
        .firstWhere((PollOption option) => option.id == optionId);
    selected.voteCount += 1;
    await poll.save();

    await _votesBox.put(
      '$userId-$pollId',
      UserVote(
        userId: userId,
        pollId: pollId,
        selectedOptionId: optionId,
      ),
    );
  }

  Future<void> deletePoll(String pollId, String currentUserId) async {
    final Poll? poll = _pollsBox.get(pollId);
    if (poll == null) {
      return;
    }
    if (poll.authorId != currentUserId) {
      throw StateError('Not authorized to delete this poll');
    }
    await _pollsBox.delete(pollId);

    final List<dynamic> keysToDelete = _votesBox.keys
        .where((dynamic key) =>
            (_votesBox.get(key) as UserVote?)?.pollId == pollId)
        .toList();
    for (final dynamic key in keysToDelete) {
      await _votesBox.delete(key);
    }
  }

  List<Poll> _filterByCategory(String categoryFilter) {
    final String normalized = categoryFilter.toLowerCase();
    Iterable<Poll> values = _pollsBox.values;
    if (normalized != 'all') {
      values = values.where(
        (Poll poll) => poll.category.toLowerCase() == normalized,
      );
    }
    return _sortPolls(values);
  }

  List<Poll> _pollsByAuthor(String authorId) {
    return _sortPolls(
      _pollsBox.values.where((Poll poll) => poll.authorId == authorId),
    );
  }

  List<Poll> _searchPolls(String normalizedQuery) {
    return _sortPolls(
      _pollsBox.values.where((Poll poll) {
        final String question = poll.question.toLowerCase();
        if (question.contains(normalizedQuery)) {
          return true;
        }
        return poll.options.any(
          (PollOption option) =>
              option.text.toLowerCase().contains(normalizedQuery),
        );
      }),
    );
  }

  List<Poll> _sortPolls(Iterable<Poll> polls) {
    final List<Poll> sorted = List<Poll>.from(polls);
    sorted.sort((Poll a, Poll b) => a.endDate.compareTo(b.endDate));
    return sorted;
  }
}
