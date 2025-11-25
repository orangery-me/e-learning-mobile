import 'package:e_learning_mobile/common/utils/datetime_converter.dart';
import 'package:e_learning_mobile/data/dtos/quizz/quizz_submit_answer.dart';
import 'package:json_annotation/json_annotation.dart';
part 'quizz_submit_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class QuizzSubmit {
  final List<QuizzSubmitAnswer> answers;
  final String enrollmentId;
  final String quizId;
  @UNIXTimestampConverter()
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
