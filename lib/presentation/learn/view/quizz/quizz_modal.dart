import 'dart:async';

import 'package:e_learning_mobile/common/extensions/context_extension.dart';
import 'package:e_learning_mobile/common/theme/palette.dart';
import 'package:e_learning_mobile/common/utils/dialog_util.dart';
import 'package:e_learning_mobile/data/dtos/quizz/quizz_overview_dto.dart';
import 'package:e_learning_mobile/data/dtos/quizz/quizz_question_dto.dart';
import 'package:e_learning_mobile/data/dtos/quizz/quizz_submit_dto.dart';
import 'package:e_learning_mobile/di/di.dart';
import 'package:e_learning_mobile/presentation/auth/bloc/auth/auth_bloc.dart';
import 'package:e_learning_mobile/presentation/learn/bloc/quizz/quizz_bloc.dart';
import 'package:e_learning_mobile/presentation/learn/view/quizz/quizz_result_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuizzPage extends StatelessWidget {
  final String quizzId;
  final String? enrollmentId;

  const QuizzPage({
    super.key,
    required this.quizzId,
    this.enrollmentId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<QuizzBloc>()..add(LoadQuizzById(quizzId)),
      child: QuizzModal(quizzId: quizzId, enrollmentId: enrollmentId),
    );
  }
}

class QuizzModal extends StatefulWidget {
  final String quizzId;
  final String? enrollmentId;

  const QuizzModal({
    super.key,
    required this.quizzId,
    this.enrollmentId,
  });

  @override
  State<QuizzModal> createState() => _QuizzModalState();
}

class _QuizzModalState extends State<QuizzModal> {
  final Map<String, int> _selectedAnswers = {};
  late final PageController _pageController;
  int _currentIndex = 0;
  int _remainingSeconds = 0;
  Timer? _timer;
  bool _autoSubmitted = false;
  bool _hasStarted = false;
  DateTime? _startedAt;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _handleSubmitConfirmed(QuizzOverviewDto quiz) {
    if (quiz.questions.isEmpty) return;

    // Cancel timer
    _timer?.cancel();
    _timer = null;

    // Get user ID
    final user = context.read<AuthBloc>().state.user;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login to submit quiz'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Check enrollmentId
    if (widget.enrollmentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enrollment ID is required to submit quiz'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Prepare submit data
    final submitAnswers = quiz.questions.map((q) {
      return QuizzSubmitAnswer(
        questionId: q.id,
        selectedAnswerIndex: _selectedAnswers[q.id] ?? -1,
      );
    }).toList();

    final submit = QuizzSubmit(
      answers: submitAnswers,
      enrollmentId: widget.enrollmentId!,
      quizId: quiz.id,
      startedAt: _startedAt ?? DateTime.now(),
      userId: user.id,
    );

    // Dispatch submit event
    context.read<QuizzBloc>().add(SubmitQuizz(submit));
  }

  void _confirmSubmit(QuizzOverviewDto quiz) {
    if (quiz.questions.isEmpty) return;

    DialogUtil.showCustomDialog(
      context,
      title: 'Submit Quiz?',
      content: 'Are you sure you want to submit your answers?',
      isConfirmDialog: true,
      cancelButtonText: 'Cancel',
      confirmButtonText: 'Submit',
      confirmAction: () => _handleSubmitConfirmed(quiz),
    );
  }

  void _startTimerIfNeeded(QuizzOverviewDto quiz) {
    if (_timer != null || quiz.timeLimitMinutes <= 0 || _autoSubmitted) return;

    // Khởi động timer sau frame hiện tại để tránh setState trong quá trình build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _timer != null || _autoSubmitted) return;

      setState(() {
        _remainingSeconds = quiz.timeLimitMinutes * 60;
      });

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        if (_remainingSeconds <= 1) {
          timer.cancel();
          if (!_autoSubmitted) {
            _autoSubmitted = true;
            // Auto submit when time is up
            final user = context.read<AuthBloc>().state.user;
            if (user != null && widget.enrollmentId != null) {
              final submitAnswers = quiz.questions.map((q) {
                return QuizzSubmitAnswer(
                  questionId: q.id,
                  selectedAnswerIndex: _selectedAnswers[q.id] ?? -1,
                );
              }).toList();

              final submit = QuizzSubmit(
                answers: submitAnswers,
                enrollmentId: widget.enrollmentId!,
                quizId: quiz.id,
                startedAt: _startedAt ?? DateTime.now(),
                userId: user.id,
              );

              context.read<QuizzBloc>().add(SubmitQuizz(submit));
            }
          }
        } else {
          setState(() {
            _remainingSeconds--;
          });
        }
      });
    });
  }

  String _formatTime(int seconds) {
    if (seconds <= 0) return '00:00';
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    final mStr = minutes.toString().padLeft(2, '0');
    final sStr = secs.toString().padLeft(2, '0');
    return '$mStr:$sStr';
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<QuizzBloc, QuizzState>(
      listenWhen: (previous, current) =>
          previous.result != current.result ||
          (previous.errorMessage != current.errorMessage &&
              current.result != null),
      listener: (context, state) {
        // Show result view when submit is successful
        if (state.result != null && !state.isLoading) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => QuizzResultView(
                result: state.result!,
                onClose: () {
                  Navigator.pop(context); // Close modal
                },
              ),
            ),
          );
        }
      },
      child: BlocBuilder<QuizzBloc, QuizzState>(
        builder: (context, state) {
          // Show loading when submitting
          if (state.isLoading && state.result == null && state.quizz != null) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Submitting Quiz...'),
                backgroundColor: Palette.light().buttonBackground,
              ),
              body: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Submitting your answers...'),
                  ],
                ),
              ),
            );
          }

          // Show error if submit failed
          if (state.errorMessage != null &&
              state.result == null &&
              state.quizz != null) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Submission Error'),
                backgroundColor: Palette.light().buttonBackground,
              ),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, color: Colors.red, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to submit quiz:\n${state.errorMessage}',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          if (state.isLoading && state.quizz == null) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state.errorMessage != null && state.quizz == null) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Quiz'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error, color: Colors.red, size: 40),
                      const SizedBox(height: 12),
                      Text(
                        'Failed to load quiz.\n${state.errorMessage}',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          context
                              .read<QuizzBloc>()
                              .add(LoadQuizzById(widget.quizzId));
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          if (state.quizz == null) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Quiz'),
                backgroundColor: Palette.light().buttonBackground,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              body: const Center(
                child: Text('No quiz data available.'),
              ),
            );
          }

          final quiz = state.quizz!;
          final questions = List<QuizzQuestionDto>.from(quiz.questions)
            ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

          // Ensure current index is in range
          if (_currentIndex >= questions.length) {
            _currentIndex = questions.isEmpty ? 0 : questions.length - 1;
          }

          return Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  const Icon(Icons.quiz, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      quiz.title,
                      style: context.textStyles.body1
                          .copyWith(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              backgroundColor: Palette.light().buttonBackground,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            body: SafeArea(
              child: _hasStarted
                  ? _buildQuizBody(context, quiz, questions)
                  : _buildOverviewBody(context, quiz, questions.length),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOverviewBody(
      BuildContext context, QuizzOverviewDto quiz, int questionCount) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quiz Overview',
            style: context.textStyles.body1.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          if (quiz.description.isNotEmpty)
            Text(
              quiz.description,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.help_outline,
                        size: 18, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      'Questions: $questionCount',
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.timer, size: 18, color: Colors.orange),
                    const SizedBox(width: 8),
                    Text(
                      'Time limit: ${quiz.timeLimitMinutes} minutes',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.check_circle,
                        size: 18, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      'Passing score: ${quiz.passingScore}%',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.repeat, size: 18, color: Colors.purple),
                    const SizedBox(width: 8),
                    Text(
                      'Max attempts: ${quiz.maxAttempts}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _hasStarted = true;
                      _startedAt = DateTime.now();
                    });
                    _startTimerIfNeeded(quiz);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.palette.buttonBackground,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Start Quiz',
                    style: context.textStyles.buttonLabel
                        .copyWith(color: context.palette.buttonText),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuizBody(BuildContext context, QuizzOverviewDto quiz,
      List<QuizzQuestionDto> questions) {
    _startTimerIfNeeded(quiz);

    return Column(
      children: [
        // Header info + countdown
        Padding(
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
                    _formatTime(_remainingSeconds),
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
        ),

        // Question summary
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  questions.isEmpty
                      ? 'No questions'
                      : 'Question ${_currentIndex + 1} of ${questions.length}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Question navigation chips
        if (questions.isNotEmpty)
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final q = questions[index];
                final isCurrent = index == _currentIndex;
                final isAnswered = _selectedAnswers.containsKey(q.id);

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
                      setState(() {
                        _currentIndex = index;
                      });
                      _pageController.animateToPage(
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
                            color:
                                isAnswered ? Colors.green : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

        // Question pager
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: questions.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final q = questions[index];
              final selectedIndex = _selectedAnswers[q.id];

              final canGoPrev = index > 0;
              final canGoNext = index < questions.length - 1;

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  children: [
                    Container(
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
                                    'Question ${index + 1}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '(${q.points} pts)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              q.questionText,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ...List.generate(q.options.length, (optIndex) {
                              return RadioListTile<int>(
                                value: optIndex,
                                groupValue: selectedIndex,
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  q.options[optIndex],
                                  style: const TextStyle(fontSize: 14),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedAnswers[q.id] = value ?? 0;
                                  });
                                },
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton.icon(
                          onPressed: canGoPrev
                              ? () {
                                  _pageController.previousPage(
                                    duration: const Duration(milliseconds: 250),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              : null,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                color: Palette.light().primaryColor,
                                width: 1.5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: Icon(Icons.arrow_back,
                              color: Palette.light().primaryColor),
                          label: Text('Previous',
                              style: context.textStyles.buttonLabel.copyWith(
                                  color: Palette.light().primaryColor)),
                        ),
                        OutlinedButton.icon(
                          onPressed: canGoNext
                              ? () {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 250),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              : null,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                color: Palette.light().primaryColor,
                                width: 1.5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          label: Text('Next',
                              style: context.textStyles.buttonLabel.copyWith(
                                  color: Palette.light().primaryColor)),
                          icon: Icon(Icons.arrow_forward,
                              color: Palette.light().primaryColor),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        // Submit button at bottom
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: questions.isEmpty ? null : () => _confirmSubmit(quiz),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.palette.buttonBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Submit Quiz',
                style: context.textStyles.buttonLabel
                    .copyWith(color: context.palette.buttonText),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
