import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class PollResultBar extends StatelessWidget {
  const PollResultBar({
    super.key,
    required this.optionText,
    required this.percentage,
    required this.isWinner,
  });

  final String optionText;
  final double percentage;
  final bool isWinner;

  @override
  Widget build(BuildContext context) {
    final Color barColor =
        isWinner ? AppTheme.highlightGreen : AppTheme.primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(
                optionText,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Text(
              '${percentage.toStringAsFixed(0)}%',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: <Widget>[
            Container(
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.black, width: 2),
              ),
            ),
            FractionallySizedBox(
              widthFactor: percentage / 100,
              child: Container(
                height: 20,
                decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.black, width: 2),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
