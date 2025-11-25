import 'package:e_learning_mobile/data/dtos/quizz/quizz_question_dto.dart';
import 'package:flutter/material.dart';

class QuizzQuestionNavigationWidget extends StatelessWidget {
  final List<QuizzQuestionDto> questions;
  final int currentIndex;
  final Map<String, int> selectedAnswers;
  final Function(int) onQuestionTap;
  final PageController pageController;

  const QuizzQuestionNavigationWidget({
    super.key,
    required this.questions,
    required this.currentIndex,
    required this.selectedAnswers,
    required this.onQuestionTap,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final q = questions[index];
          final isCurrent = index == currentIndex;
          final isAnswered = selectedAnswers.containsKey(q.id);

          Color bgColor;
          Color textColor;
          if (isCurrent) {
            bgColor = Colors.blue;
            textColor = Colors.white;
          } else if (isAnswered) {
            bgColor = Colors.green.shade50;
            textColor = Colors.green;
          } else {
            bgColor = Colors.grey.shade200;
            textColor = Colors.grey.shade800;
          }

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                onQuestionTap(index);
                pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: bgColor,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isAnswered ? Colors.green : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
