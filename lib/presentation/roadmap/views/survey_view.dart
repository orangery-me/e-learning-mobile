import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_learning_mobile/common/extensions/context_extension.dart';
import 'package:e_learning_mobile/presentation/roadmap/bloc/roadmap_bloc.dart';
import 'package:e_learning_mobile/presentation/roadmap/widgets/survey_question_widget.dart';
import 'package:e_learning_mobile/presentation/widgets/common_rounded_button.dart';

class SurveyView extends StatelessWidget {
  const SurveyView({super.key});

  static const List<Map<String, dynamic>> questions = [
    {
      'key': 'role',
      'question': 'Which job role are you aiming for?',
      'options': [
        'Software Engineer',
        'AI / Machine Learning Engineer',
        'Frontend Developer',
        'Backend Developer',
        'Mobile App Developer',
        'DevOps / Cloud Engineer',
        'Data Engineer',
      ],
    },
    {
      'key': 'goal',
      'question': 'What is your career goal in the next 6–12 months?',
      'options': [
        'Get a high-paying remote job',
        'Get promoted to a Senior position',
        'Switch to a new tech field',
        'Land my first full-time tech job',
        'Prepare for international job opportunities',
      ],
    },
    {
      'key': 'experience',
      'question': 'What is your current level of experience?',
      'options': [
        'No professional experience yet',
        'Less than 1 year',
        '1–2 years',
        '3–5 years',
        '5–8 years',
        'More than 8 years',
      ],
    },
    {
      'key': 'preferredStack',
      'question': 'Which technology or domain do you want to focus on?',
      'options': [
        'React',
        'Node.js',
        'Python',
        'Flutter / React Native',
        'AI / Machine Learning',
        'Cloud & DevOps',
        'Java',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoadmapBloc, RoadmapState>(
      builder: (context, state) {
        final currentIndex = state.currentQuestionIndex;
        final currentQuestion = questions[currentIndex];
        final currentAnswer =
            state.surveyAnswers[currentQuestion['key'] as String];

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SurveyQuestionWidget(
                    question: currentQuestion['question'] as String,
                    questionKey: currentQuestion['key'] as String,
                    currentAnswer: currentAnswer,
                    options: currentQuestion['options'] as List<String>,
                    onAnswerChanged: (answer) {
                      context.read<RoadmapBloc>().add(
                            UpdateSurveyAnswer(
                              currentQuestion['key'] as String,
                              answer,
                            ),
                          );
                    },
                    currentStep: currentIndex,
                    totalSteps: questions.length,
                  ),
                ),
                // Navigation Buttons
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Button
                      if (state.canGoToPreviousQuestion)
                        Expanded(
                          child: CommonRoundedButton(
                            onPressed: () {
                              context.read<RoadmapBloc>().add(
                                    const NavigateToPreviousQuestion(),
                                  );
                            },
                            content: 'Back',
                            backgroundColor: Colors.grey[100],
                            textStyle: TextStyle(
                              color: context.palette.normalText,
                              fontWeight: FontWeight.w600,
                            ),
                            borderSide: BorderSide(
                              color: Colors.grey[300]!,
                              width: 1,
                            ),
                          ),
                        ),
                      // else
                      //   const Expanded(child: SizedBox()),
                      const SizedBox(width: 16),
                      // Continue Button
                      Expanded(
                        // if on the last question, make button take full width
                        flex: state.canGoToPreviousQuestion ? 1 : 2,
                        child: CommonRoundedButton(
                          onPressed: () {
                            if (currentIndex == questions.length - 1) {
                              // Submit survey
                              context
                                  .read<RoadmapBloc>()
                                  .add(SubmitSurvey(state.surveyAnswers));
                            } else {
                              context
                                  .read<RoadmapBloc>()
                                  .add(const NavigateToNextQuestion());
                            }
                          },
                          content: currentIndex == questions.length - 1
                              ? 'Submit'
                              : 'Continue',
                          backgroundColor: context.palette.buttonBackground,
                          isDisable: currentIndex == questions.length - 1
                              ? !state.canSubmitSurvey
                              : !state.canGoToNextQuestion,
                        ),
                      ),
                    ],
                  ),
                ),
                // Step Indicator
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Text(
                    'Question ${currentIndex + 1}/${questions.length}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
