import 'dart:developer';

import 'package:e_learning_mobile/data/dtos/code/judge_response/judge_result_response_dto.dart';
import 'package:e_learning_mobile/data/dtos/code/judge_response/feedback_response_dto.dart';
import 'package:e_learning_mobile/data/dtos/code/problem_statement/code_problem_statement.dart';
import 'package:e_learning_mobile/di/di.dart';
import 'package:e_learning_mobile/presentation/learn/bloc/code_exercise/code_exercise_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const List<Map<String, dynamic>> languages = [
  {'name': 'Python (3.8.1)', 'id': 71},
  {'name': 'C++ (GCC 9.2.0)', 'id': 54},
  {'name': 'C (GCC 9.2.0)', 'id': 50},
  {'name': 'Java (OpenJDK 13.0.1)', 'id': 62},
  {'name': 'JavaScript (Node.js 12.14.0)', 'id': 63},
  {'name': 'Go (1.13.5)', 'id': 60},
  {'name': 'TypeScript (3.7.4)', 'id': 74},
];

enum RunMode { runOnly, aiJudge }

class CodeExercisePage extends StatelessWidget {
  final CodeProblemStatement? problemStatement;
  const CodeExercisePage({super.key, this.problemStatement});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CodeExerciseBloc>(),
      child: CodeExerciseModal(problemStatement: problemStatement),
    );
  }
}

class CodeExerciseModal extends StatefulWidget {
  final CodeProblemStatement? problemStatement;
  const CodeExerciseModal({super.key, this.problemStatement});

  @override
  State<CodeExerciseModal> createState() => _CodeExerciseModalState();
}

class _CodeExerciseModalState extends State<CodeExerciseModal> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _stdinController = TextEditingController();
  final TextEditingController _expectedController = TextEditingController();
  final TextEditingController _problemController = TextEditingController();
  // RunMode _selectedMode = RunMode.runOnly;

  String _selectedLanguage = '71';

  @override
  void dispose() {
    _codeController.dispose();
    _stdinController.dispose();
    _expectedController.dispose();
    super.dispose();
  }

  String _getStateResult(JudgeResultResponseDto result) {
    return result.stdout ??
        result.stderr ??
        result.compileOutput ??
        result.message ??
        'No output';
  }

  Widget _buildJudgeResultArea(JudgeResultResponseDto result) {
    final statusDesc = result.status.description;
    final isAccepted = statusDesc.toLowerCase().contains('accepted');
    final isWrong = statusDesc.toLowerCase().contains('wrong');
    final isError = statusDesc.toLowerCase().contains('error');

    Color badgeColor;
    String badgeText;
    if (isAccepted) {
      badgeColor = Colors.green;
      badgeText = 'Accepted';
    } else if (isWrong) {
      badgeColor = Colors.red;
      badgeText = 'Wrong Answer';
    } else if (isError) {
      badgeColor = Colors.orange;
      badgeText = 'Runtime Error';
    } else {
      badgeColor = Colors.grey;
      badgeText = statusDesc;
    }

    return _OutlinedArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Text(
                  'Result',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: badgeColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    badgeText,
                    style: TextStyle(
                      color: badgeColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Time & Memory
            Row(
              children: [
                Text('Time: ${result.time ?? '0'}s'),
                const SizedBox(width: 20),
                Text('Memory: ${result.memory ?? '0'} KB'),
              ],
            ),

            const SizedBox(height: 16),

            // Output
            const Text(
              'Output (stdout):',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0B1020),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _getStateResult(result),
                style: const TextStyle(
                  fontFamily: 'monospace',
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackArea(FeedBackResponseDto feedback) {
    log('Building feedback area with feedback: ${feedback.toJson()}');
    return _OutlinedArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Icon(Icons.psychology, color: Colors.purple, size: 24),
                const SizedBox(width: 8),
                const Text(
                  'AI Feedback',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                if (feedback.score != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getScoreColor(feedback.score!).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Score: ${feedback.score}/100',
                      style: TextStyle(
                        color: _getScoreColor(feedback.score!),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // Summary
            if (feedback.summary != null) ...[
              const Text(
                'Summary',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Text(
                  feedback.summary!,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Code Quality Metrics
            if (feedback.codeQualityMetricsDto != null) ...[
              const Text(
                'Code Quality Metrics',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      'Efficiency',
                      feedback.codeQualityMetricsDto!.efficiency,
                      Colors.green,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildMetricCard(
                      'Readability',
                      feedback.codeQualityMetricsDto!.readability,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildMetricCard(
                      'Best Practices',
                      feedback.codeQualityMetricsDto!.bestPractices,
                      Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],

            // Strengths
            if (feedback.strengths != null &&
                feedback.strengths!.isNotEmpty) ...[
              const Text(
                'Strengths',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: feedback.strengths!
                      .map((strength) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.check_circle,
                                    color: Colors.green, size: 16),
                                const SizedBox(width: 8),
                                Expanded(
                                    child: Text(strength,
                                        style: const TextStyle(fontSize: 14))),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Weaknesses
            if (feedback.weaknesses != null &&
                feedback.weaknesses!.isNotEmpty) ...[
              const Text(
                'Areas for Improvement',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: feedback.weaknesses!
                      .map((weakness) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.warning,
                                    color: Colors.orange, size: 16),
                                const SizedBox(width: 8),
                                Expanded(
                                    child: Text(weakness,
                                        style: const TextStyle(fontSize: 14))),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Suggestions
            if (feedback.suggestions != null &&
                feedback.suggestions!.isNotEmpty) ...[
              const Text(
                'Suggestions',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.purple.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: feedback.suggestions!
                      .map((suggestion) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.lightbulb,
                                    color: Colors.purple, size: 16),
                                const SizedBox(width: 8),
                                Expanded(
                                    child: Text(suggestion,
                                        style: const TextStyle(fontSize: 14))),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, double value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${(value * 100).toInt()}%',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  Widget _runButton() {
    return SizedBox(
      width: double.infinity,
      child: BlocBuilder<CodeExerciseBloc, CodeExerciseState>(
        builder: (context, state) {
          return ElevatedButton.icon(
            onPressed: state.isLoading
                ? null
                : () {
                    if (_codeController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter some code')),
                      );
                      return;
                    }

                    // log('problemDescription: ${_selectedMode == RunMode.aiJudge ? _problemController.text.trim() : 'N/A'}');

                    context.read<CodeExerciseBloc>().add(ExecuteCodeEvent(
                          sourceCode: _codeController.text.trim(),
                          languageId: int.parse(_selectedLanguage),
                          stdin: _stdinController.text.trim().isEmpty
                              ? null
                              : _stdinController.text.trim(),
                          expectedOutput:
                              _expectedController.text.trim().isEmpty
                                  ? null
                                  : _expectedController.text.trim(),
                          problemDescription: _problemController.text.trim(),
                        ));
                  },
            icon: state.isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.play_arrow),
            label: Text(state.isLoading ? 'Running...' : 'Run'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Center(
                    child: Text(
                      'Code Exercises',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      context.read<CodeExerciseBloc>().add(ClearResult());
                      Navigator.pop(context);
                    }),
              ],
            ),
            const SizedBox(height: 8),

            // Language selector
            Row(
              children: [
                const Text('Language:',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: _selectedLanguage,
                  items: languages
                      .map((language) => DropdownMenuItem(
                          value: language['id'].toString(),
                          child: Text(language['name'] as String)))
                      .toList(),
                  onChanged: (v) =>
                      setState(() => _selectedLanguage = v ?? '71'),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Mode selector
            // Row(
            //   children: [
            //     const Text('Mode:',
            //         style: TextStyle(fontWeight: FontWeight.w600)),
            //     const SizedBox(width: 12),
            //     DropdownButton<RunMode>(
            //       value: _selectedMode,
            //       items: const [
            //         DropdownMenuItem(
            //           value: RunMode.runOnly,
            //           child: Text('Run code only'),
            //         ),
            //         DropdownMenuItem(
            //           value: RunMode.aiJudge,
            //           child: Text('AI Judge (with Gemini)'),
            //         ),
            //       ],
            //       onChanged: (v) =>
            //           setState(() => _selectedMode = v ?? RunMode.runOnly),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 8),

            // Problem description (if AI Judge)
            // if (_selectedMode == RunMode.aiJudge) ...[
            const SizedBox(height: 12),
            const Text('Problem description',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text(widget.problemStatement?.problemStatement ??
                widget.problemStatement?.title ??
                'No problem description provided.'),
            // _OutlinedArea(
            //   child: TextField(
            //     controller: _problemController,
            //     minLines: 3,
            //     maxLines: 6,
            //     keyboardType: TextInputType.multiline,
            //     decoration: const InputDecoration(
            //       hintText: 'Enter problem statement...',
            //       border: InputBorder.none,
            //       isCollapsed: true,
            //       contentPadding: EdgeInsets.all(12),
            //     ),
            //   ),
            // ),
            // ],
            const SizedBox(height: 12),

            // Code editor
            const Text('Code', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            _OutlinedArea(
              child: TextField(
                controller: _codeController,
                minLines: 8,
                maxLines: 18,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText: 'Write your code here...',
                  border: InputBorder.none,
                  isCollapsed: true,
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Standard input
            const Text('Standard input (optional)',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            _OutlinedArea(
              child: TextField(
                controller: _stdinController,
                minLines: 2,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText: 'Enter stdin...',
                  border: InputBorder.none,
                  isCollapsed: true,
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Expected output
            const Text('Expected output (optional)',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            _OutlinedArea(
              child: TextField(
                controller: _expectedController,
                minLines: 2,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText: 'Enter expected output...',
                  border: InputBorder.none,
                  isCollapsed: true,
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Run button
            _runButton(),

            const SizedBox(height: 8),

            // Result box
            BlocBuilder<CodeExerciseBloc, CodeExerciseState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const _OutlinedArea(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 8),
                          Text('Executing code...'),
                        ],
                      ),
                    ),
                  );
                }

                if (state.errorMessage != null) {
                  return _OutlinedArea(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error, color: Colors.red, size: 48),
                          const SizedBox(height: 8),
                          Text('Error: ${state.errorMessage}'),
                        ],
                      ),
                    ),
                  );
                }

                if (state.result != null) {
                  return Column(
                    children: [
                      _buildJudgeResultArea(state.result!.judgeResult),
                      if (state.result!.feedbackResult != null) ...[
                        const SizedBox(height: 16),
                        _buildFeedbackArea(state.result!.feedbackResult!),
                      ],
                    ],
                  );
                }

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  height: 200,
                  child: Center(
                    child: Text(
                      '// Result will appear here\n',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        color: Colors.grey,
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class _OutlinedArea extends StatelessWidget {
  final Widget child;
  const _OutlinedArea({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: child,
    );
  }
}
