// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoEvent _$VideoEventFromJson(Map<String, dynamic> json) => VideoEvent(
      id: json['id'] as String,
      lectureId: json['lectureId'] as String,
      eventType: VideoEventType.fromJson(json['eventType'] as String),
      triggerTime: (json['triggerTime'] as num).toInt(),
      payload: json['payload'] as String,
    );

Map<String, dynamic> _$VideoEventToJson(VideoEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'lectureId': instance.lectureId,
      'eventType': _$VideoEventTypeEnumMap[instance.eventType]!,
      'triggerTime': instance.triggerTime,
      'payload': instance.payload,
    };

const _$VideoEventTypeEnumMap = {
  VideoEventType.CODE: 'CODE',
  VideoEventType.QUIZ: 'QUIZ',
};
