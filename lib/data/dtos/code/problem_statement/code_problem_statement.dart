import 'package:e_learning_mobile/data/dtos/code/problem_statement/test_case.dart';
import 'package:json_annotation/json_annotation.dart';
part 'code_problem_statement.g.dart';

@JsonSerializable()
class CodeProblemStatement {
  final String id;
  final String lectureId;
  final String title;
  final String problemStatement;
  final int timeLimitSeconds;
  final DateTime createdAt;
  final List<TestCase> testCases;
  CodeProblemStatement({
    required this.id,
    required this.lectureId,
    required this.title,
    required this.problemStatement,
    required this.timeLimitSeconds,
    required this.createdAt,
    required this.testCases,
  });

  factory CodeProblemStatement.fromJson(Map<String, dynamic> json) =>
      _$CodeProblemStatementFromJson(json);
}
