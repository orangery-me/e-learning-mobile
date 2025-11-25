import 'package:json_annotation/json_annotation.dart';
part 'quizz_submit_answer.g.dart';

@JsonSerializable()
class QuizzSubmitAnswer {
  final String questionId;
  final int selectedAnswerIndex;

  QuizzSubmitAnswer({
    required this.questionId,
    required this.selectedAnswerIndex,
  });

  factory QuizzSubmitAnswer.fromJson(Map<String, dynamic> json) =>
      _$QuizzSubmitAnswerFromJson(json);

  Map<String, dynamic> toJson() => _$QuizzSubmitAnswerToJson(this);
}
