import 'package:json_annotation/json_annotation.dart';

part 'video_event.g.dart';

enum VideoEventType {
  CODE,
  QUIZ;

  // frome json
  factory VideoEventType.fromJson(String value) {
    return VideoEventType.values
        .firstWhere((e) => e.name.toLowerCase() == value.toLowerCase());
  }
}

@JsonSerializable()
class VideoEvent {
  final String id;
  final String lectureId;
  final VideoEventType eventType;
  final int triggerTime;
  final String payload;

  VideoEvent({
    required this.id,
    required this.lectureId,
    required this.eventType,
    required this.triggerTime,
    required this.payload,
  });

  factory VideoEvent.fromJson(Map<String, dynamic> json) =>
      _$VideoEventFromJson(json);
}
