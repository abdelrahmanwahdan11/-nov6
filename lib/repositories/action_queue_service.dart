import 'package:hive/hive.dart';

import '../models/action_queue_item.dart';

class ActionQueueService {
  ActionQueueService(this._queueBox);

  final Box<ActionQueueItem> _queueBox;

  static const String actionCreatePoll = 'create_poll';
  static const String actionVote = 'vote';

  Future<void> enqueueCreatePoll({
    required String question,
    required List<String> optionTexts,
    required int durationMinutes,
    required String authorId,
    required String authorName,
    required String category,
  }) async {
    await _save(
      ActionQueueItem(
        id: _generateId(),
        actionType: actionCreatePoll,
        payload: <String, dynamic>{
          'question': question,
          'options': optionTexts,
          'durationMinutes': durationMinutes,
          'authorId': authorId,
          'authorName': authorName,
          'category': category,
        },
      ),
    );
  }

  Future<void> enqueueVote({
    required String pollId,
    required String optionId,
    required String userId,
  }) async {
    await _save(
      ActionQueueItem(
        id: _generateId(),
        actionType: actionVote,
        payload: <String, dynamic>{
          'pollId': pollId,
          'optionId': optionId,
          'userId': userId,
        },
      ),
    );
  }

  List<ActionQueueItem> pendingActions() {
    return _queueBox.values.toList(growable: false);
  }

  Future<void> remove(String id) {
    return _queueBox.delete(id);
  }

  Future<void> clear() {
    return _queueBox.clear();
  }

  Future<void> _save(ActionQueueItem item) async {
    await _queueBox.put(item.id, item);
  }

  String _generateId() {
    final int timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'action-$timestamp-${_queueBox.length}';
  }
}
