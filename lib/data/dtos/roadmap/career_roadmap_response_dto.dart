import 'package:json_annotation/json_annotation.dart';

part 'career_roadmap_response_dto.g.dart';

@JsonSerializable()
class CareerRoadmapSectionDto {
  @JsonKey(name: 'section_title')
  final String sectionTitle;
  final String description;
  @JsonKey(name: 'course_ids')
  final List<String> courseIds;

  CareerRoadmapSectionDto({
    required this.sectionTitle,
    required this.description,
    required this.courseIds,
  });

  factory CareerRoadmapSectionDto.fromJson(Map<String, dynamic> json) =>
      _$CareerRoadmapSectionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CareerRoadmapSectionDtoToJson(this);
}

@JsonSerializable()
class CareerRoadmapResponseDto {
  final String role;
  final String goal;
  final List<CareerRoadmapSectionDto> sections;

  CareerRoadmapResponseDto({
    required this.role,
    required this.goal,
    required this.sections,
  });

  factory CareerRoadmapResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CareerRoadmapResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CareerRoadmapResponseDtoToJson(this);
}


