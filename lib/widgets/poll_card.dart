import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';
import '../models/poll.dart';
import '../repositories/mock_poll_repository.dart';
import '../theme/app_theme.dart';

class PollCard extends StatelessWidget {
  const PollCard({
    super.key,
    required this.poll,
    required this.authorName,
    this.onDelete,
  });

  final Poll poll;
  final String authorName;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final Duration remaining = poll.endDate.difference(DateTime.now());
    final int hours = max(0, remaining.inHours);
    final int totalVotes = poll.options.fold<int>(
      0,
      (int previousValue, option) => previousValue + option.voteCount,
    );
    final int topVotes = poll.options.fold<int>(
      0,
      (int previousValue, option) => max(previousValue, option.voteCount),
    );
    final double progress = totalVotes == 0 ? 0 : topVotes / totalVotes;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () => context.go('/poll/${poll.id}'),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      poll.question,
                      style: textTheme.headlineMedium,
                    ),
                  ),
                  if (onDelete != null)
                    IconButton(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete_outline),
                      tooltip: l10n.delete,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.mustard,
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      l10n.createdBy(authorName),
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      _categoryLabel(poll.category, l10n),
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    l10n.hoursShort(hours),
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: progress,
                minHeight: 12,
                backgroundColor: Colors.white,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppTheme.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _categoryLabel(String category, AppLocalizations l10n) {
  switch (category.toLowerCase()) {
    case 'tech':
      return l10n.categoryTech;
    case 'fun':
      return l10n.categoryFun;
    case 'work':
      return l10n.categoryWork;
    case 'general':
    default:
      return l10n.categoryGeneral;
  }
}
