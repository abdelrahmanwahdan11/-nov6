import '../models/action_queue_item.dart';
import 'action_queue_service.dart';
import 'mock_poll_repository.dart';

class MockSyncService {
  MockSyncService(this._queueService, this._pollRepository);

  final ActionQueueService _queueService;
  final MockPollRepository _pollRepository;

  Future<void> processQueue() async {
    final List<ActionQueueItem> actions = _queueService.pendingActions();
    for (final ActionQueueItem action in actions) {
      try {
        switch (action.actionType) {
          case ActionQueueService.actionCreatePoll:
            await _handleCreatePoll(action.payload);
            break;
          case ActionQueueService.actionVote:
            await _handleVote(action.payload);
            break;
          default:
            break;
        }
      } finally {
        await _queueService.remove(action.id);
      }
    }
  }

  Future<void> _handleCreatePoll(Map<String, dynamic> payload) async {
    final String question = payload['question'] as String? ?? '';
    final List<dynamic> optionsRaw = payload['options'] as List<dynamic>? ?? <dynamic>[];
    final int durationMinutes = payload['durationMinutes'] as int? ?? 0;
    final String authorId = payload['authorId'] as String? ?? '';
    final String authorName = payload['authorName'] as String? ?? '';
    final String category = payload['category'] as String? ?? 'General';

    if (question.isEmpty || optionsRaw.isEmpty || authorId.isEmpty) {
      return;
    }

    final List<String> optionTexts = optionsRaw.cast<String>();
    await _pollRepository.createPoll(
      question: question,
      optionTexts: optionTexts,
      duration: Duration(minutes: durationMinutes),
      authorId: authorId,
      authorName: authorName,
      category: category,
    );
  }

  Future<void> _handleVote(Map<String, dynamic> payload) async {
    final String pollId = payload['pollId'] as String? ?? '';
    final String optionId = payload['optionId'] as String? ?? '';
    final String userId = payload['userId'] as String? ?? '';
    if (pollId.isEmpty || optionId.isEmpty || userId.isEmpty) {
      return;
    }

    await _pollRepository.addVote(
      pollId: pollId,
      optionId: optionId,
      userId: userId,
    );
  }
}
