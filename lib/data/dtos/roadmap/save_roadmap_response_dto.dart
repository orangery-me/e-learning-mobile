import 'package:json_annotation/json_annotation.dart';
import 'package:e_learning_mobile/data/dtos/roadmap/career_roadmap_response_dto.dart';

part 'save_roadmap_response_dto.g.dart';

@JsonSerializable()
class SaveRoadmapResponseDto {
  @JsonKey(name: 'plan_id')
  final String planId;
  @JsonKey(name: 'user_id')
  final String userId;
  final String role;
  final String goal;
  final List<CareerRoadmapSectionDto> sections;
  final Map<String, String> answers;
  @JsonKey(name: 'overall_progress')
  final double overallProgress;

  SaveRoadmapResponseDto({
    required this.planId,
    required this.userId,
    required this.role,
    required this.goal,
    required this.sections,
    required this.answers,
    required this.overallProgress,
  });

  factory SaveRoadmapResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SaveRoadmapResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SaveRoadmapResponseDtoToJson(this);
}

