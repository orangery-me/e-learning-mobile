import 'package:flutter/material.dart';
import 'package:e_learning_mobile/common/extensions/context_extension.dart';
import 'package:e_learning_mobile/presentation/widgets/common_text_form_field.dart';
import 'package:e_learning_mobile/presentation/roadmap/widgets/gradient_progress_bar.dart';

class SurveyQuestionWidget extends StatelessWidget {
  final String question;
  final String questionKey;
  final String? currentAnswer;
  final List<String> options;
  final Function(String) onAnswerChanged;
  final int currentStep;
  final int totalSteps;

  const SurveyQuestionWidget({
    super.key,
    required this.question,
    required this.questionKey,
    this.currentAnswer,
    required this.options,
    required this.onAnswerChanged,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (currentStep + 1) / totalSteps;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            // Character Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: context.palette.buttonBackground,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Face/Head
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Eyes
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF106C54),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF106C54),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        // Glasses frame
                        Positioned(
                          top: 10,
                          child: Container(
                            width: 40,
                            height: 16,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFF106C54),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        // Smile
                        Positioned(
                          bottom: 12,
                          child: Container(
                            width: 20,
                            height: 10,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFF106C54),
                                width: 2,
                              ),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Code symbol on chest
                  Positioned(
                    bottom: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        '</>',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF106C54),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Question Text
            Text(
              question,
              style: context.textStyles.heading1?.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: context.palette.normalText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            // Text Input Field
            CommonTextFormField(
              initialValue: currentAnswer,
              hintText: 'Type your answer here',
              borderRadius: 12,
              onChanged: (value) {
                onAnswerChanged(value);
              },
            ),
            const SizedBox(height: 24),
            // Progress Bar with Gradient
            GradientProgressBar(
              value: progress,
              height: 8,
            ),
            const SizedBox(height: 32),
            // Option Chips
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: options.map((option) {
                final isSelected = currentAnswer == option;
                return GestureDetector(
                  onTap: () => onAnswerChanged(option),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? context.palette.buttonBackground.withOpacity(0.1)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? context.palette.buttonBackground
                            : Colors.grey[300]!,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      option,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected
                            ? context.palette.buttonBackground
                            : context.palette.normalText,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
