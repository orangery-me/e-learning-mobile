// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseResponseDto _$CourseResponseDtoFromJson(Map<String, dynamic> json) =>
    CourseResponseDto(
      courseId: json['courseId'] as String,
      title: json['title'] as String,
      slug: json['slug'] as String?,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      level: json['level'] as String?,
      instructorId: json['instructorId'] as String,
      instructorName: json['instructorName'] as String?,
      category: json['category'] as String,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$CourseResponseDtoToJson(CourseResponseDto instance) =>
    <String, dynamic>{
      'courseId': instance.courseId,
      'title': instance.title,
      'slug': instance.slug,
      'description': instance.description,
      'price': instance.price,
      'level': instance.level,
      'instructorId': instance.instructorId,
      'instructorName': instance.instructorName,
      'category': instance.category,
      'image': instance.image,
    };
