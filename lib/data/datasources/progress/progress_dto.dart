import 'package:e_learning_mobile/common/utils/datetime_converter.dart';
import 'package:json_annotation/json_annotation.dart';
part 'progress_dto.g.dart';

@JsonSerializable()
class ProgressDto {
  final String id;
  @JsonKey(name: 'completion_date')
  @DateTimeTimestampConverter()
  final DateTime? completionDate;
  @JsonKey(name: 'created_at')
  @DateTimeTimestampConverter()
  final DateTime? createdAt;
  final bool? isCompleted;
  @JsonKey(name: 'updated_at')
  @DateTimeTimestampConverter()
  final DateTime? updatedAt;
  @JsonKey(name: 'last_viewed_at')
  @DateTimeTimestampConverter()
  final DateTime? lastViewedAt;
  @JsonKey(name: 'enrollment_id')
  final String enrollmentId;
  @JsonKey(name: 'lecture_id')
  final String lectureId;
  @JsonKey(name: 'section_id')
  final String sectionId;
  final String? videoUrl;

  // Video position in seconds (if API returns milliseconds, use fromJson converter)
  @JsonKey(
      name: 'video_position',
      fromJson: _videoPositionFromJson,
      toJson: _videoPositionToJson)
  final int? videoPositionSeconds;

  ProgressDto({
    required this.id,
    this.completionDate,
    this.createdAt,
    this.isCompleted,
    required this.updatedAt,
    this.lastViewedAt,
    required this.enrollmentId,
    required this.lectureId,
    required this.sectionId,
    this.videoUrl,
    this.videoPositionSeconds,
  });

  // Helper to convert from API (supports both seconds and milliseconds)
  static int? _videoPositionFromJson(dynamic json) {
    if (json == null) return null;
    final value = json is int ? json : (json as num).toInt();
    // If value > 1 hour in seconds (3600), assume it's milliseconds, convert to seconds
    // Otherwise assume it's already in seconds
    if (value > 3600 && value < 86400000) {
      // Likely milliseconds, convert to seconds
      return value ~/ 1000;
    }
    // Already in seconds or very small value
    return value;
  }

  static int? _videoPositionToJson(int? seconds) => seconds;

  factory ProgressDto.fromJson(Map<String, dynamic> json) =>
      _$ProgressDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProgressDtoToJson(this);

  // helper to convert last viewed at to seconds
  int get lastViewedAtSeconds =>
      Duration(milliseconds: lastViewedAt?.millisecondsSinceEpoch ?? 0)
          .inSeconds;
}
