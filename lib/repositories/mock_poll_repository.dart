import 'dart:math';

import 'package:hive/hive.dart';

import '../models/poll.dart';
import '../models/poll_option.dart';
import '../models/user_mock.dart';
import '../models/user_vote.dart';

const String pollsBoxName = 'polls_box';
const String votesBoxName = 'votes_box';
const String usersBoxName = 'users_box';
const String currentUserId = 'user-neo';

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
        currentUserId,
        UserMock(
          id: currentUserId,
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
        authorId: currentUserId,
        endDate: now.add(const Duration(hours: 6)),
      ),
      Poll(
        id: 'poll-2',
        question: 'Pick the soundtrack for the next product reveal.',
        options: <PollOption>[
          PollOption(id: 'o-4', text: 'Analog synthwave', voteCount: 12),
          PollOption(id: 'o-5', text: 'Lo-fi brutal beats', voteCount: 15),
          PollOption(id: 'o-6', text: 'Future garage', voteCount: 8),
        ],
        authorId: currentUserId,
        endDate: now.add(const Duration(hours: 12)),
      ),
    ];

    for (final Poll poll in defaults) {
      await _pollsBox.put(poll.id, poll);
    }
  }

  Future<List<Poll>> getPopularPolls() async {
    final List<Poll> polls = _pollsBox.values.toList()
      ..sort((Poll a, Poll b) => a.endDate.compareTo(b.endDate));
    return polls;
  }

  Future<List<Poll>> getPollsByAuthor(String authorId) async {
    return _pollsBox.values
        .where((Poll poll) => poll.authorId == authorId)
        .toList();
  }

  UserMock? getCurrentUser() {
    return _usersBox.get(currentUserId);
  }

  Future<Poll?> getPollById(String id) {
    return Future<Poll?>.value(_pollsBox.get(id));
  }

  Future<Poll> createPoll({
    required String question,
    required List<String> optionTexts,
    required Duration duration,
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
      authorId: currentUserId,
      endDate: endDate,
    );

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
}
