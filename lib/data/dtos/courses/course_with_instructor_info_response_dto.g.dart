// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_with_instructor_info_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseWithInstructorInfoResponseDto
    _$CourseWithInstructorInfoResponseDtoFromJson(Map<String, dynamic> json) =>
        CourseWithInstructorInfoResponseDto(
          courseId: json['courseId'] as String,
          title: json['title'] as String,
          slug: json['slug'] as String?,
          description: json['description'] as String?,
          price: (json['price'] as num).toDouble(),
          level: json['level'] as String?,
          instructor:
              UserInfoDto.fromJson(json['instructor'] as Map<String, dynamic>),
          category: json['category'] as String,
          image: json['image'] as String?,
        );

Map<String, dynamic> _$CourseWithInstructorInfoResponseDtoToJson(
        CourseWithInstructorInfoResponseDto instance) =>
    <String, dynamic>{
      'courseId': instance.courseId,
      'title': instance.title,
      'slug': instance.slug,
      'description': instance.description,
      'price': instance.price,
      'level': instance.level,
      'instructor': instance.instructor,
      'category': instance.category,
      'image': instance.image,
    };
