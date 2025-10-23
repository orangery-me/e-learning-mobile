// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'code_problem_statement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CodeProblemStatement _$CodeProblemStatementFromJson(
        Map<String, dynamic> json) =>
    CodeProblemStatement(
      id: json['id'] as String,
      lectureId: json['lectureId'] as String,
      title: json['title'] as String,
      problemStatement: json['problemStatement'] as String,
      timeLimitSeconds: (json['timeLimitSeconds'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      testCases: (json['testCases'] as List<dynamic>)
          .map((e) => TestCase.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CodeProblemStatementToJson(
        CodeProblemStatement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'lectureId': instance.lectureId,
      'title': instance.title,
      'problemStatement': instance.problemStatement,
      'timeLimitSeconds': instance.timeLimitSeconds,
      'createdAt': instance.createdAt.toIso8601String(),
      'testCases': instance.testCases,
    };
