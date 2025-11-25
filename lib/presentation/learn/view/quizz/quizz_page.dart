import 'dart:async';
import 'dart:math';

import 'package:e_learning_mobile/common/extensions/context_extension.dart';
import 'package:e_learning_mobile/common/theme/palette.dart';
import 'package:e_learning_mobile/common/utils/dialog_util.dart';
import 'package:e_learning_mobile/data/dtos/quizz/quizz_overview_dto.dart';
import 'package:e_learning_mobile/data/dtos/quizz/quizz_question_dto.dart';
import 'package:e_learning_mobile/data/dtos/quizz/quizz_submit_answer.dart';
import 'package:e_learning_mobile/data/dtos/quizz/quizz_submit_dto.dart';
import 'package:e_learning_mobile/di/di.dart';
import 'package:e_learning_mobile/presentation/auth/bloc/auth/auth_bloc.dart';
import 'package:e_learning_mobile/presentation/learn/bloc/quizz/quizz_bloc.dart';
import 'package:e_learning_mobile/presentation/learn/view/quizz/models/shuffled_question.dart';
import 'package:e_learning_mobile/presentation/learn/view/quizz/quizz_overview_view.dart';
import 'package:e_learning_mobile/presentation/learn/view/quizz/quizz_result_view.dart';
import 'package:e_learning_mobile/presentation/learn/view/quizz/widgets/quizz_header_widget.dart';
import 'package:e_learning_mobile/presentation/learn/view/quizz/widgets/quizz_navigation_buttons_widget.dart';
import 'package:e_learning_mobile/presentation/learn/view/quizz/widgets/quizz_question_card_widget.dart';
import 'package:e_learning_mobile/presentation/learn/view/quizz/widgets/quizz_question_navigation_widget.dart';
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
  final Map<String, int> _selectedAnswers = {}; // Stores shuffled index
  late final PageController _pageController;
  int _currentIndex = 0;
  int _remainingSeconds = 0;
  Timer? _timer;
  bool _autoSubmitted = false;
  bool _hasStarted = false;
  DateTime? _startedAt;
  List<ShuffledQuestion> _shuffledQuestions = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // Load attempts when modal opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthBloc>().state.user;
      if (user != null) {
        context
            .read<QuizzBloc>()
            .add(LoadUserAttempts(widget.quizzId, user.id));
      }
    });
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

    // Prepare submit data - convert shuffled indices back to original indices
    final submitAnswers = _shuffledQuestions.map((shuffledQ) {
      final shuffledIndex = _selectedAnswers[shuffledQ.originalQuestion.id];
      final originalIndex = shuffledIndex != null
          ? shuffledQ.getOriginalIndex(shuffledIndex)
          : null;

      return QuizzSubmitAnswer(
        questionId: shuffledQ.originalQuestion.id,
        selectedAnswerIndex: originalIndex ?? -1,
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
              // Convert shuffled indices back to original indices
              final submitAnswers = _shuffledQuestions.map((shuffledQ) {
                final shuffledIndex =
                    _selectedAnswers[shuffledQ.originalQuestion.id];
                final originalIndex = shuffledIndex != null
                    ? shuffledQ.getOriginalIndex(shuffledIndex)
                    : null;

                return QuizzSubmitAnswer(
                  questionId: shuffledQ.originalQuestion.id,
                  selectedAnswerIndex: originalIndex ?? -1,
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
          // Reset quiz state to show overview when coming back
          setState(() {
            _hasStarted = false;
            _autoSubmitted = false;
            _selectedAnswers.clear();
            _currentIndex = 0;
            _shuffledQuestions.clear();
            _timer?.cancel();
            _timer = null;
          });

          // Reload attempts after submission
          final user = context.read<AuthBloc>().state.user;
          if (user != null) {
            context
                .read<QuizzBloc>()
                .add(LoadUserAttempts(widget.quizzId, user.id));
          }

          // Navigate to result view
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => QuizzResultView(
                result: state.result!,
                onClose: () {
                  // Pop back to overview
                  Navigator.pop(context);
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

          // Initialize shuffled questions if not started or if list is empty
          if (_shuffledQuestions.isEmpty && quiz.questions.isNotEmpty) {
            // Sort by sortOrder first
            final sortedQuestions = List<QuizzQuestionDto>.from(quiz.questions)
              ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

            // Shuffle questions order
            sortedQuestions.shuffle(Random());

            // Create shuffled questions with shuffled options
            _shuffledQuestions = sortedQuestions
                .map((q) => ShuffledQuestion.fromOriginal(q))
                .toList();
          }

          // Ensure current index is in range
          if (_currentIndex >= _shuffledQuestions.length) {
            _currentIndex =
                _shuffledQuestions.isEmpty ? 0 : _shuffledQuestions.length - 1;
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
                  ? _buildQuizBody(context, quiz, _shuffledQuestions)
                  : QuizzOverviewView(
                      quiz: quiz,
                      questionCount: _shuffledQuestions.isEmpty
                          ? quiz.questions.length
                          : _shuffledQuestions.length,
                      attempts: state.attempts,
                      isLoadingAttempts:
                          state.isLoading && state.attempts == null,
                      onStartQuiz: () {
                        // Check if user has reached max attempts
                        final attemptsCount = state.attempts?.length ?? 0;
                        if (attemptsCount >= quiz.maxAttempts) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'You have run out of attempts to take this quiz',
                              ),
                              backgroundColor: Colors.orange,
                              duration: Duration(seconds: 3),
                            ),
                          );
                          return;
                        }

                        setState(() {
                          _hasStarted = true;
                          _startedAt = DateTime.now();
                        });
                        _startTimerIfNeeded(quiz);
                      },
                      onCancel: () => Navigator.pop(context),
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuizBody(BuildContext context, QuizzOverviewDto quiz,
      List<ShuffledQuestion> shuffledQuestions) {
    _startTimerIfNeeded(quiz);

    return Column(
      children: [
        // Header info + countdown
        QuizzHeaderWidget(
          quiz: quiz,
          remainingTime: _formatTime(_remainingSeconds),
        ),

        // Question summary
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  shuffledQuestions.isEmpty
                      ? 'No questions'
                      : 'Question ${_currentIndex + 1} of ${shuffledQuestions.length}',
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
        QuizzQuestionNavigationWidget(
          questions:
              shuffledQuestions.map((sq) => sq.originalQuestion).toList(),
          currentIndex: _currentIndex,
          selectedAnswers: _selectedAnswers,
          onQuestionTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          pageController: _pageController,
        ),

        // Question pager
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: shuffledQuestions.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final shuffledQ = shuffledQuestions[index];
              final selectedIndex =
                  _selectedAnswers[shuffledQ.originalQuestion.id];

              final canGoPrev = index > 0;
              final canGoNext = index < shuffledQuestions.length - 1;

              // Create a temporary question DTO with shuffled options for display
              final displayQuestion = QuizzQuestionDto(
                id: shuffledQ.originalQuestion.id,
                questionText: shuffledQ.originalQuestion.questionText,
                options: shuffledQ.shuffledOptions,
                correctAnswerIndex: shuffledQ.shuffledCorrectIndex,
                points: shuffledQ.originalQuestion.points,
                sortOrder: shuffledQ.originalQuestion.sortOrder,
                createdAt: shuffledQ.originalQuestion.createdAt,
              );

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  children: [
                    QuizzQuestionCardWidget(
                      question: displayQuestion,
                      questionNumber: index + 1,
                      selectedIndex: selectedIndex,
                      onAnswerSelected: (shuffledIndex) {
                        setState(() {
                          _selectedAnswers[shuffledQ.originalQuestion.id] =
                              shuffledIndex;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    QuizzNavigationButtonsWidget(
                      canGoPrev: canGoPrev,
                      canGoNext: canGoNext,
                      onPrevious: canGoPrev
                          ? () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeInOut,
                              );
                            }
                          : null,
                      onNext: canGoNext
                          ? () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeInOut,
                              );
                            }
                          : null,
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
              onPressed:
                  shuffledQuestions.isEmpty ? null : () => _confirmSubmit(quiz),
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
