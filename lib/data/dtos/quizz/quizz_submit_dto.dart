import 'package:json_annotation/json_annotation.dart';
part 'quizz_submit_dto.g.dart';

@JsonSerializable()
class QuizzSubmit {
  final List<QuizzSubmitAnswer> answers;
  final String enrollmentId;
  final String quizId;
  final DateTime startedAt;
  final String userId;

  QuizzSubmit({
    required this.answers,
    required this.enrollmentId,
    required this.quizId,
    required this.startedAt,
    required this.userId,
  });

  factory QuizzSubmit.fromJson(Map<String, dynamic> json) =>
      _$QuizzSubmitFromJson(json);

  Map<String, dynamic> toJson() => _$QuizzSubmitToJson(this);
}

class QuizzSubmitAnswer {
  final String questionId;
  final int selectedAnswerIndex;

  QuizzSubmitAnswer({
    required this.questionId,
    required this.selectedAnswerIndex,
  });

  Map<String, dynamic> toJson() => {
        'questionId': questionId,
        'selectedAnswerIndex': selectedAnswerIndex,
      };

  factory QuizzSubmitAnswer.fromJson(Map<String, dynamic> json) {
    return QuizzSubmitAnswer(
      questionId: json['questionId'] as String,
      selectedAnswerIndex: json['selectedAnswerIndex'] as int,
    );
  }
}
