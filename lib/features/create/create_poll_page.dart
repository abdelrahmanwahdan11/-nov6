import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/poll_providers.dart';
import '../../repositories/mock_poll_repository.dart';
import '../../theme/app_theme.dart';
import 'poll_settings_page.dart';

class CreatePollPage extends ConsumerStatefulWidget {
  const CreatePollPage({super.key});

  static const String routeName = 'create';

  @override
  ConsumerState<CreatePollPage> createState() => _CreatePollPageState();
}

class _CreatePollPageState extends ConsumerState<CreatePollPage> {
  final TextEditingController _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers = <TextEditingController>[
    TextEditingController(),
    TextEditingController(),
  ];

  PollSettingsArguments _settings = const PollSettingsArguments();
  bool _isSaving = false;

  @override
  void dispose() {
    _questionController.dispose();
    for (final TextEditingController controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _addOptionField() async {
    setState(() {
      _optionControllers.add(TextEditingController());
    });
  }

  void _removeOptionField(int index) {
    if (_optionControllers.length <= 2) {
      return;
    }
    setState(() {
      _optionControllers.removeAt(index).dispose();
    });
  }

  Future<void> _openSettings(BuildContext context) async {
    final PollSettingsArguments? result = await context.push<PollSettingsArguments>(
      '/create/settings',
      extra: _settings,
    );
    if (result != null) {
      setState(() {
        _settings = result;
      });
    }
  }

  Future<void> _publishPoll(AppLocalizations l10n) async {
    final String question = _questionController.text.trim();
    final List<String> options = _optionControllers
        .map((TextEditingController controller) => controller.text.trim())
        .where((String text) => text.isNotEmpty)
        .toList();

    if (question.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.enterQuestionError)),
      );
      return;
    }

    if (options.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.needTwoOptionsError)),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final MockPollRepository repository = ref.read(mockPollRepositoryProvider);
      final poll = await repository.createPoll(
        question: question,
        optionTexts: options,
        duration: _settings.duration,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.pollCreatedSuccess),
          backgroundColor: AppTheme.primaryColor,
        ),
      );

      context.go('/poll/${poll.id}');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.createPollHeader),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: _questionController,
                decoration: InputDecoration(
                  labelText: l10n.pollQuestionLabel,
                ),
              ),
              const SizedBox(height: 24),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: _optionControllers[index],
                          decoration: InputDecoration(
                            labelText:
                                '${l10n.optionLabel} ${index + 1}',
                            hintText: l10n.optionHint(index + 1),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (_optionControllers.length > 2)
                        IconButton(
                          onPressed: () => _removeOptionField(index),
                          icon: const Icon(Icons.close),
                        ),
                    ],
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemCount: _optionControllers.length,
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _addOptionField,
                icon: const Icon(Icons.add),
                label: Text(l10n.addOption),
              ),
              const SizedBox(height: 24),
              Card(
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  title: Text(l10n.pollSettings),
                  subtitle: Text(
                    '${l10n.durationLabel}: ${_settings.duration.inHours}h',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _openSettings(context),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : () => _publishPoll(l10n),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.publish),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
