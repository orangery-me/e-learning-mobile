import 'package:json_annotation/json_annotation.dart';
part 'test_case.g.dart';

@JsonSerializable()
class TestCase {
  final String id;
  final String inputData;
  final String expectedOutput;
  final int points;
  final bool isHidden;
  final int sortOrder;

  TestCase({
    required this.id,
    required this.inputData,
    required this.expectedOutput,
    required this.points,
    required this.isHidden,
    required this.sortOrder,
  });
  factory TestCase.fromJson(Map<String, dynamic> json) =>
      _$TestCaseFromJson(json);
}
