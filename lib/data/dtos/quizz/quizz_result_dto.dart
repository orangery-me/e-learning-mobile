import 'package:e_learning_mobile/data/dtos/quizz/quizz_answer_dto.dart';
import 'package:json_annotation/json_annotation.dart';
part 'quizz_result_dto.g.dart';

@JsonSerializable()
class QuizzResultDto {
  final String id;
  final String quizId;
  final String quizTitle;
  final String userId;
  final String userEmail;
  final int attemptNumber;
  final double totalScore;
  final double maxPossibleScore;
  final double scorePercentage;
  final bool isPassed;
  final DateTime submittedAt;
  final int timeTakenMinutes;
  final bool isCompleted;
  final List<QuizzAnswerDto> answers;
  QuizzResultDto({
    required this.id,
    required this.quizId,
    required this.quizTitle,
    required this.userId,
    required this.userEmail,
    required this.attemptNumber,
    required this.totalScore,
    required this.maxPossibleScore,
    required this.scorePercentage,
    required this.isPassed,
    required this.submittedAt,
    required this.timeTakenMinutes,
    required this.isCompleted,
    required this.answers,
  });

  factory QuizzResultDto.fromJson(Map<String, dynamic> json) =>
      _$QuizzResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$QuizzResultDtoToJson(this);
}
