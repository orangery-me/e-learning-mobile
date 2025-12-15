import 'package:json_annotation/json_annotation.dart';
import 'package:e_learning_mobile/data/dtos/roadmap/career_roadmap_response_dto.dart';

part 'save_roadmap_request_dto.g.dart';

@JsonSerializable()
class SaveRoadmapRequestDto {
  final String role;
  final String goal;
  final List<CareerRoadmapSectionDto> sections;
  final Map<String, String> answers;

  SaveRoadmapRequestDto({
    required this.role,
    required this.goal,
    required this.sections,
    required this.answers,
  });

  factory SaveRoadmapRequestDto.fromJson(Map<String, dynamic> json) =>
      _$SaveRoadmapRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SaveRoadmapRequestDtoToJson(this);
}

