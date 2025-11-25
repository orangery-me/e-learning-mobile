import 'package:e_learning_mobile/data/dtos/quizz/quizz_overview_dto.dart';
import 'package:flutter/material.dart';

class QuizzHeaderWidget extends StatelessWidget {
  final QuizzOverviewDto quiz;
  final String remainingTime;

  const QuizzHeaderWidget({
    super.key,
    required this.quiz,
    required this.remainingTime,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (quiz.description.isNotEmpty) ...[
            Text(
              quiz.description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
          ],
          Row(
            children: [
              const Icon(Icons.timer, size: 16, color: Colors.blue),
              const SizedBox(width: 4),
              Text(
                '${quiz.timeLimitMinutes} min',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.check_circle, size: 16, color: Colors.green),
              const SizedBox(width: 4),
              Text(
                'Pass: ${quiz.passingScore}%',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              const Icon(Icons.alarm, size: 16, color: Colors.red),
              const SizedBox(width: 4),
              Text(
                remainingTime,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
