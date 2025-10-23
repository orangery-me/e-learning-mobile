// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_case.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TestCase _$TestCaseFromJson(Map<String, dynamic> json) => TestCase(
      id: json['id'] as String,
      inputData: json['inputData'] as String,
      expectedOutput: json['expectedOutput'] as String,
      points: (json['points'] as num).toInt(),
      isHidden: json['isHidden'] as bool,
      sortOrder: (json['sortOrder'] as num).toInt(),
    );

Map<String, dynamic> _$TestCaseToJson(TestCase instance) => <String, dynamic>{
      'id': instance.id,
      'inputData': instance.inputData,
      'expectedOutput': instance.expectedOutput,
      'points': instance.points,
      'isHidden': instance.isHidden,
      'sortOrder': instance.sortOrder,
    };
