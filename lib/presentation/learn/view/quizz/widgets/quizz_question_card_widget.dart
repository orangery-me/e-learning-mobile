import 'package:e_learning_mobile/data/dtos/quizz/quizz_question_dto.dart';
import 'package:flutter/material.dart';

class QuizzQuestionCardWidget extends StatelessWidget {
  final QuizzQuestionDto question;
  final int questionNumber;
  final int? selectedIndex;
  final Function(int) onAnswerSelected;

  const QuizzQuestionCardWidget({
    super.key,
    required this.question,
    required this.questionNumber,
    required this.selectedIndex,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Question $questionNumber',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '(${question.points} pts)',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                )
              ],
            ),
            const SizedBox(height: 8),
            Text(
              question.questionText,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(question.options.length, (optIndex) {
              return RadioListTile<int>(
                value: optIndex,
                groupValue: selectedIndex,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  question.options[optIndex],
                  style: const TextStyle(fontSize: 14),
                ),
                onChanged: (value) {
                  if (value != null) {
                    onAnswerSelected(value);
                  }
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
