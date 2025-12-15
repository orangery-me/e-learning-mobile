import 'package:json_annotation/json_annotation.dart';

part 'career_roadmap_request_dto.g.dart';

@JsonSerializable()
class CareerRoadmapRequestDto {
  final String role;
  final String goal;
  final Map<String, String> answers;

  CareerRoadmapRequestDto({
    required this.role,
    required this.goal,
    required this.answers,
  });

  factory CareerRoadmapRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CareerRoadmapRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CareerRoadmapRequestDtoToJson(this);
}


