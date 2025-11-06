import 'dart:convert';

import 'package:hive/hive.dart';

import '../models/poll.dart';
import '../models/poll_option.dart';
import '../models/user.dart';
import '../models/user_vote.dart';

class ExportDataService {
  ExportDataService(
    this._pollsBox,
    this._votesBox,
    this._usersBox,
  );

  final Box<Poll> _pollsBox;
  final Box<UserVote> _votesBox;
  final Box<User> _usersBox;

  Future<String> generateUserJson(String userId) async {
    final User? user = _usersBox.get(userId);
    final Iterable<Poll> myPolls =
        _pollsBox.values.where((Poll poll) => poll.authorId == userId);
    final Iterable<UserVote> myVotes =
        _votesBox.values.where((UserVote vote) => vote.userId == userId);

    final Map<String, dynamic> exportData = <String, dynamic>{
      'user': user == null
          ? null
          : <String, dynamic>{
              'id': user.id,
              'name': user.name,
              'email': user.email,
            },
      'polls': myPolls.map(_pollToJson).toList(),
      'votes': myVotes
          .map((UserVote vote) => <String, dynamic>{
                'pollId': vote.pollId,
                'optionId': vote.selectedOptionId,
              })
          .toList(),
    };

    return const JsonEncoder.withIndent('  ').convert(exportData);
  }

  Map<String, dynamic> _pollToJson(Poll poll) {
    return <String, dynamic>{
      'id': poll.id,
      'question': poll.question,
      'category': poll.category,
      'endDate': poll.endDate.toIso8601String(),
      'options': poll.options.map(_optionToJson).toList(),
    };
  }

  Map<String, dynamic> _optionToJson(PollOption option) {
    return <String, dynamic>{
      'id': option.id,
      'text': option.text,
      'voteCount': option.voteCount,
    };
  }
}
