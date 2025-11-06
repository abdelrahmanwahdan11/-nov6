import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class PollSettingsArguments {
  const PollSettingsArguments({
    this.duration = const Duration(hours: 6),
    this.hideParticipants = false,
    this.allowSharing = true,
  });

  final Duration duration;
  final bool hideParticipants;
  final bool allowSharing;

  PollSettingsArguments copyWith({
    Duration? duration,
    bool? hideParticipants,
    bool? allowSharing,
  }) {
    return PollSettingsArguments(
      duration: duration ?? this.duration,
      hideParticipants: hideParticipants ?? this.hideParticipants,
      allowSharing: allowSharing ?? this.allowSharing,
    );
  }
}

class PollSettingsPage extends StatefulWidget {
  const PollSettingsPage({super.key, this.arguments = const PollSettingsArguments()});

  static const String routeName = 'settings';

  final PollSettingsArguments arguments;

  @override
  State<PollSettingsPage> createState() => _PollSettingsPageState();
}

class _PollSettingsPageState extends State<PollSettingsPage> {
  late Duration _selectedDuration;
  late bool _hideParticipants;
  late bool _allowSharing;

  final List<Duration> _durations = <Duration>[
    const Duration(hours: 6),
    const Duration(hours: 12),
    const Duration(days: 1),
    const Duration(days: 3),
  ];

  @override
  void initState() {
    super.initState();
    _selectedDuration = widget.arguments.duration;
    _hideParticipants = widget.arguments.hideParticipants;
    _allowSharing = widget.arguments.allowSharing;
  }

  void _reset() {
    setState(() {
      _selectedDuration = const Duration(hours: 6);
      _hideParticipants = false;
      _allowSharing = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.pollSettingsTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              l10n.durationLabel,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _durations.map((Duration duration) {
                final bool isSelected = _selectedDuration == duration;
                return ChoiceChip(
                  selected: isSelected,
                  label: Text(_durationText(duration)),
                  onSelected: (_) => setState(() => _selectedDuration = duration),
                  labelStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                  selectedColor: Colors.black,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.black, width: 2),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            SwitchListTile(
              value: _hideParticipants,
              onChanged: (bool value) =>
                  setState(() => _hideParticipants = value),
              title: Text(l10n.hideParticipants),
            ),
            SwitchListTile(
              value: _allowSharing,
              onChanged: (bool value) => setState(() => _allowSharing = value),
              title: Text(l10n.allowSharing),
            ),
            const Spacer(),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton(
                    onPressed: _reset,
                    child: Text(l10n.reset),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(
                        PollSettingsArguments(
                          duration: _selectedDuration,
                          hideParticipants: _hideParticipants,
                          allowSharing: _allowSharing,
                        ),
                      );
                    },
                    child: Text(l10n.done),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _durationText(Duration duration) {
    if (duration.inDays >= 1) {
      return '${duration.inDays} d';
    }
    return '${duration.inHours} h';
  }
}
