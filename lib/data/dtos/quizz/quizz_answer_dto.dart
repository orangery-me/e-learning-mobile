import 'package:json_annotation/json_annotation.dart';
part 'quizz_answer_dto.g.dart';

@JsonSerializable()
class QuizzAnswerDto {
  final String questionId;
  final String questionText;
  final List<String> options;
  final int selectedAnswerIndex;
  final int correctAnswerIndex;
  final bool isCorrect;
  final double pointsEarned;
  final double maxPoints;
  QuizzAnswerDto({
    required this.questionId,
    required this.questionText,
    required this.options,
    required this.selectedAnswerIndex,
    required this.correctAnswerIndex,
    required this.isCorrect,
    required this.pointsEarned,
    required this.maxPoints,
  });

  factory QuizzAnswerDto.fromJson(Map<String, dynamic> json) =>
      _$QuizzAnswerDtoFromJson(json);

  Map<String, dynamic> toJson() => _$QuizzAnswerDtoToJson(this);
}
