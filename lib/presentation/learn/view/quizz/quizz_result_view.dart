import 'package:e_learning_mobile/common/extensions/context_extension.dart';
import 'package:e_learning_mobile/common/theme/palette.dart';
import 'package:e_learning_mobile/data/dtos/quizz/quizz_answer_dto.dart';
import 'package:e_learning_mobile/data/dtos/quizz/quizz_result_dto.dart';
import 'package:flutter/material.dart';

class QuizzResultView extends StatelessWidget {
  final QuizzResultDto result;
  final VoidCallback? onClose;

  const QuizzResultView({
    super.key,
    required this.result,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.quiz, color: Colors.white),
            SizedBox(width: 12),
            Text('Quiz Results', style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: Palette.light().buttonBackground,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: onClose ?? () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Score Summary Card
              _buildScoreSummaryCard(context),
              const SizedBox(height: 24),

              // Quiz Info
              _buildQuizInfo(context),
              const SizedBox(height: 24),

              // Results Breakdown
              Text(
                'Question Review',
                style: context.textStyles.body1.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Answers List
              ...result.answers.asMap().entries.map((entry) {
                final index = entry.key;
                final answer = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildAnswerCard(context, answer, index + 1),
                );
              }),

              // Close Button
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: onClose ?? () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.palette.buttonBackground,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Close',
                    style: context.textStyles.buttonLabel
                        .copyWith(color: context.palette.buttonText),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreSummaryCard(BuildContext context) {
    final percentage = result.scorePercentage;
    final isPassed = result.isPassed;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isPassed
              ? [Colors.green.shade400, Colors.green.shade600]
              : [Colors.orange.shade400, Colors.orange.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (isPassed ? Colors.green : Colors.orange).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Icon
          Icon(
            isPassed ? Icons.check_circle : Icons.error,
            size: 48,
            color: Colors.white,
          ),
          const SizedBox(height: 12),

          // Title
          Text(
            isPassed ? 'Congratulations!' : 'Keep Practicing!',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),

          // Score Percentage
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${percentage.toStringAsFixed(1)}',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Text(
                '%',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Score Details
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildScoreDetail(
                  'Score',
                  '${result.totalScore.toStringAsFixed(0)}/${result.maxPossibleScore.toStringAsFixed(0)}',
                  Colors.white,
                ),
                Container(
                  width: 1,
                  height: 24,
                  color: Colors.white.withOpacity(0.3),
                ),
                _buildScoreDetail(
                  'Correct',
                  '${result.answers.where((a) => a.isCorrect).length}/${result.answers.length}',
                  Colors.white,
                ),
                Container(
                  width: 1,
                  height: 24,
                  color: Colors.white.withOpacity(0.3),
                ),
                _buildScoreDetail(
                  'Attempt',
                  '#${result.attemptNumber}',
                  Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreDetail(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color.withOpacity(0.9),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildQuizInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: 18, color: Colors.grey.shade700),
              const SizedBox(width: 8),
              Text(
                'Quiz Information',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildInfoRow('Quiz', result.quizTitle),
          _buildInfoRow(
            'Time Taken',
            '${result.timeTakenMinutes} minutes',
          ),
          _buildInfoRow(
            'Submitted At',
            '${result.submittedAt.day}/${result.submittedAt.month}/${result.submittedAt.year} '
                '${result.submittedAt.hour}:${result.submittedAt.minute.toString().padLeft(2, '0')}',
          ),
          if (result.isCompleted)
            _buildInfoRow('Status', 'Completed', Colors.green)
          else
            _buildInfoRow('Status', 'Incomplete', Colors.orange),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, [Color? valueColor]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: valueColor ?? Colors.grey.shade800,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerCard(
      BuildContext context, QuizzAnswerDto answer, int questionNumber) {
    final isCorrect = answer.isCorrect;
    final userSelected = answer.selectedAnswerIndex;
    final correctAnswer = answer.correctAnswerIndex;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCorrect ? Colors.green.shade300 : Colors.red.shade300,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: (isCorrect ? Colors.green : Colors.red).withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: (isCorrect ? Colors.green : Colors.red).shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: (isCorrect ? Colors.green : Colors.red).shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Question $questionNumber',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: (isCorrect ? Colors.green : Colors.red).shade800,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isCorrect ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isCorrect ? Icons.check : Icons.close,
                        size: 14,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isCorrect ? 'Correct' : 'Incorrect',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${answer.pointsEarned.toStringAsFixed(0)}/${answer.maxPoints.toStringAsFixed(0)} pts',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade800,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Question Text
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  answer.questionText,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),

                // Options
                ...answer.options.asMap().entries.map((entry) {
                  final index = entry.key;
                  final option = entry.value;
                  final isUserAnswer = index == userSelected;
                  final isCorrectAnswer = index == correctAnswer;

                  Color? bgColor;
                  Color? borderColor;
                  IconData? icon;
                  Color? iconColor;

                  if (isCorrectAnswer) {
                    // Correct answer - always show
                    bgColor = Colors.green.shade50;
                    borderColor = Colors.green.shade300;
                    icon = Icons.check_circle;
                    iconColor = Colors.green;
                  } else if (isUserAnswer && !isCorrectAnswer) {
                    // User's wrong answer
                    bgColor = Colors.red.shade50;
                    borderColor = Colors.red.shade300;
                    icon = Icons.cancel;
                    iconColor = Colors.red;
                  } else {
                    // Other options
                    bgColor = Colors.grey.shade50;
                    borderColor = Colors.grey.shade300;
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: borderColor,
                        width: isUserAnswer || isCorrectAnswer ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        if (icon != null)
                          Icon(icon, color: iconColor, size: 18)
                        else
                          const SizedBox(width: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            option,
                            style: TextStyle(
                              fontSize: 13,
                              color: isUserAnswer || isCorrectAnswer
                                  ? Colors.black87
                                  : Colors.grey.shade700,
                              fontWeight: isUserAnswer || isCorrectAnswer
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (isUserAnswer)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isCorrectAnswer ? Colors.green : Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Your Answer',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        if (isCorrectAnswer && !isUserAnswer)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Correct Answer',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
