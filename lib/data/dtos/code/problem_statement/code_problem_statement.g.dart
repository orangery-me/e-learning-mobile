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
      title: json['title'] as String?,
      problemStatement: json['problemStatement'] as String?,
      timeLimitSeconds: (json['timeLimitSeconds'] as num?)?.toInt(),
      createdAt: _$JsonConverterFromJson<int, DateTime>(
          json['createdAt'], const DateTimeTimestampConverter().fromJson),
      testCases: (json['testCases'] as List<dynamic>?)
          ?.map((e) => TestCase.fromJson(e as Map<String, dynamic>))
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
      'createdAt': _$JsonConverterToJson<int, DateTime>(
          instance.createdAt, const DateTimeTimestampConverter().toJson),
      'testCases': instance.testCases,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
