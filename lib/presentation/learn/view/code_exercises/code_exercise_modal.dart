import 'dart:developer';

import 'package:e_learning_mobile/common/extensions/context_extension.dart';
import 'package:e_learning_mobile/common/theme/palette.dart';
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
  final String problemId;
  const CodeExercisePage({super.key, required this.problemId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<CodeExerciseBloc>()..add(LoadProblemStatement(problemId)),
      child: CodeExerciseModal(problemId: problemId),
    );
  }
}

class CodeExerciseModal extends StatefulWidget {
  final String problemId;
  const CodeExerciseModal({super.key, required this.problemId});

  @override
  State<CodeExerciseModal> createState() => _CodeExerciseModalState();
}

class _CodeExerciseModalState extends State<CodeExerciseModal>
    with TickerProviderStateMixin {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _stdinController = TextEditingController();
  final TextEditingController _expectedController = TextEditingController();
  final TextEditingController _problemController = TextEditingController();

  String _selectedLanguage = '71';
  late TabController _tabController;
  int _selectedTestCaseIndex = 0;
  int _tabLength = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabLength, vsync: this);
  }

  @override
  void dispose() {
    _codeController.dispose();
    _tabController.dispose();
    _stdinController.dispose();
    _expectedController.dispose();
    super.dispose();
  }

  void _updateTabController(bool hasProblem) {
    final desiredLength = hasProblem ? 3 : 1;
    if (_tabLength == desiredLength) return;
    final previousIndex = _tabController.index
        .clamp(0, (desiredLength - 1).clamp(0, desiredLength - 1));
    _tabLength = desiredLength;
    _tabController.dispose();
    _tabController = TabController(
      length: _tabLength,
      vsync: this,
      initialIndex: previousIndex.toInt(),
    );
  }

  void _populateDefaultTestCase(CodeProblemStatement problem) {
    final nonHiddenTestCases =
        problem.testCases?.where((tc) => !tc.isHidden).toList() ?? [];
    if (!mounted) return;
    setState(() {
      if (nonHiddenTestCases.isNotEmpty) {
        _stdinController.text = nonHiddenTestCases[0].inputData;
        _expectedController.text = nonHiddenTestCases[0].expectedOutput;
      } else {
        _stdinController.clear();
        _expectedController.clear();
      }
      _selectedTestCaseIndex = 0;
    });
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
                : const Icon(Icons.play_arrow, color: Colors.white),
            label: Text(state.isLoading ? 'Running...' : 'Run',
                style: TextStyle(color: context.palette.buttonText)),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.palette.buttonBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProblemTab(CodeProblemStatement problem) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            if (problem.title != null) ...[
              Text(
                problem.title!,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Problem Statement
            if (problem.problemStatement != null) ...[
              const Text(
                'Problem Statement',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                problem.problemStatement!,
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 16),
            ],

            // Time Limit
            if (problem.timeLimitSeconds != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.timer, size: 18, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      'Time limit: ${problem.timeLimitSeconds}s',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            // Test Cases Info
            if (problem.testCases != null && problem.testCases!.isNotEmpty) ...[
              const Text(
                'Test Cases',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Total: ${problem.testCases!.length} test cases',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCodeTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Language selector
            Row(
              children: [
                const Icon(Icons.code, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Language:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButton<String>(
                    value: _selectedLanguage,
                    isExpanded: true,
                    items: languages
                        .map((language) => DropdownMenuItem(
                              value: language['id'].toString(),
                              child: Text(language['name'] as String),
                            ))
                        .toList(),
                    onChanged: (v) =>
                        setState(() => _selectedLanguage = v ?? '71'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Code editor
            const Text(
              'Code',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            _OutlinedArea(
              child: TextField(
                controller: _codeController,
                minLines: 10,
                maxLines: 20,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText: 'Write your code here...',
                  border: InputBorder.none,
                  isCollapsed: true,
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Run button
            _runButton(),
            const SizedBox(height: 16),

            // Result box
            _buildResultArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildTestCasesTab(CodeProblemStatement problem) {
    if (problem.testCases == null || problem.testCases!.isEmpty) {
      return const Center(
        child: Text('No test cases available'),
      );
    }

    final testCases = problem.testCases!;
    final nonHiddenTestCases = testCases.where((tc) => !tc.isHidden).toList();

    if (nonHiddenTestCases.isEmpty) {
      return const Center(
        child: Text('All test cases are hidden'),
      );
    }

    // Update selected index if needed
    if (_selectedTestCaseIndex >= nonHiddenTestCases.length) {
      _selectedTestCaseIndex = 0;
    }

    final selectedTestCase = nonHiddenTestCases[_selectedTestCaseIndex];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Test case selector
            Row(
              children: [
                const Icon(Icons.view_list, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Select Test Case:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: nonHiddenTestCases.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text('Case ${index + 1}'),
                      selected: _selectedTestCaseIndex == index,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedTestCaseIndex = index;
                            // Update stdin and expected output
                            _stdinController.text =
                                nonHiddenTestCases[index].inputData;
                            _expectedController.text =
                                nonHiddenTestCases[index].expectedOutput;
                          });
                        }
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Input Data
            Row(
              children: [
                const Icon(Icons.input, size: 20, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  'Input',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _OutlinedArea(
              child: TextField(
                controller: _stdinController,
                minLines: 4,
                maxLines: 8,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText: 'Test case input will appear here...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Expected Output
            Row(
              children: [
                const Icon(Icons.check_circle, size: 20, color: Colors.green),
                const SizedBox(width: 8),
                const Text(
                  'Expected Output',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _OutlinedArea(
              child: TextField(
                controller: _expectedController,
                minLines: 2,
                maxLines: 6,
                enabled: false,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText: 'Expected output for this test case...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
                  fillColor: Color(0xFFF5F5F5),
                  filled: true,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Points info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.stars, color: Colors.orange, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Points: ${selectedTestCase.points}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultArea() {
    return BlocBuilder<CodeExerciseBloc, CodeExerciseState>(
      builder: (context, state) {
        if (state.isLoading) {
          return _OutlinedArea(
            child: const Padding(
              padding: EdgeInsets.all(32),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Executing code...'),
                  ],
                ),
              ),
            ),
          );
        }

        if (state.errorMessage != null) {
          return _OutlinedArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 48),
                    const SizedBox(height: 8),
                    Text(
                      'Error: ${state.errorMessage}',
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
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

        return _OutlinedArea(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.code, size: 48, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  Text(
                    'Run your code to see results here',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomTestLayout() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Language selector
            Row(
              children: [
                const Icon(Icons.code, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Language:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButton<String>(
                    value: _selectedLanguage,
                    isExpanded: true,
                    items: languages
                        .map((language) => DropdownMenuItem(
                              value: language['id'].toString(),
                              child: Text(language['name'] as String),
                            ))
                        .toList(),
                    onChanged: (v) =>
                        setState(() => _selectedLanguage = v ?? '71'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Code editor
            const Text(
              'Code',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            _OutlinedArea(
              child: TextField(
                controller: _codeController,
                minLines: 10,
                maxLines: 20,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText: 'Write your code here...',
                  border: InputBorder.none,
                  isCollapsed: true,
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Standard input
            const Text(
              'Standard Input',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            _OutlinedArea(
              child: TextField(
                controller: _stdinController,
                minLines: 3,
                maxLines: 6,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText: 'Enter stdin...',
                  border: InputBorder.none,
                  isCollapsed: true,
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Expected output
            const Text(
              'Expected Output',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
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
            const SizedBox(height: 16),

            // Run button
            _runButton(),
            const SizedBox(height: 16),

            // Result box
            _buildResultArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildProblemLoadError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 12),
            Text(
              'Failed to load exercise',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.redAccent, fontSize: 13),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                context
                    .read<CodeExerciseBloc>()
                    .add(LoadProblemStatement(widget.problemId));
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CodeExerciseBloc, CodeExerciseState>(
      listenWhen: (previous, current) =>
          previous.problemStatement != current.problemStatement,
      listener: (_, state) {
        final problem = state.problemStatement;
        if (problem != null) {
          _populateDefaultTestCase(problem);
        }
      },
      child: BlocBuilder<CodeExerciseBloc, CodeExerciseState>(
        builder: (context, state) {
          final problem = state.problemStatement;
          final hasProblem = problem != null;
          _updateTabController(hasProblem);

          return Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  const Icon(Icons.code, size: 24, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      problem?.title ?? 'Code Exercise',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
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
              bottom: hasProblem
                  ? TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.white,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white60,
                      tabs: const [
                        Tab(
                            icon: Icon(Icons.description, color: Colors.white),
                            text: 'Problem'),
                        Tab(
                            icon: Icon(Icons.code, color: Colors.white),
                            text: 'Code'),
                        Tab(
                            icon: Icon(Icons.check_circle, color: Colors.white),
                            text: 'Tests'),
                      ],
                    )
                  : null,
            ),
            body: () {
              if (state.isProblemLoading && !hasProblem) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.problemErrorMessage != null && !hasProblem) {
                return _buildProblemLoadError(
                    context, state.problemErrorMessage!);
              }

              if (problem != null) {
                final resolvedProblem = problem;
                return TabBarView(
                  controller: _tabController,
                  children: [
                    _buildProblemTab(resolvedProblem),
                    _buildCodeTab(),
                    _buildTestCasesTab(resolvedProblem),
                  ],
                );
              }

              return _buildCustomTestLayout();
            }(),
          );
        },
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
