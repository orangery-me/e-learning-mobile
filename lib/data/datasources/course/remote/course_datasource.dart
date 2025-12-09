import 'dart:developer';

import 'package:e_learning_mobile/common/constants/endpoints.dart';
import 'package:e_learning_mobile/common/helpers/dio_helper.dart';
import 'package:e_learning_mobile/data/dtos/courses/course_with_instructor_info_response_dto.dart';
import 'package:e_learning_mobile/data/dtos/courses/course_response_dto.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CourseRemoteDatasource {
  CourseRemoteDatasource({required DioHelper dioHelper})
      : _dioHelper = dioHelper;
  final DioHelper _dioHelper;

  Future<List<CourseWithInstructorInfoResponseDto>> fetchCourses(
      {String? order = 'asc',
      int? page = 1,
      int? size = 10,
      String? sortBy = 'created_at',
      String? filter,
      String? query}) async {
    try {
      final response = await _dioHelper
          .get('${Endpoints.courses}/page-v2', queryParameters: {
        if (page != null) 'page': page,
        if (size != null) 'paging': size,
        if (order != null) 'order': order,
        if (sortBy != null) 'sort': sortBy,
        if (filter != null) 'filter': filter,
        if (query != null && query.isNotEmpty) 'search': query,
      });

      // Parse and return the list of courses from response
      return (response.data['data'] as List)
          .map((course) => CourseWithInstructorInfoResponseDto.fromJson(course))
          .toList();
    } catch (e) {
      log('Error fetching courses: $e');
      rethrow;
    }
  }

  // get course by id
  Future<CourseResponseDto> fetchCourseById(String courseId) async {
    final response = await _dioHelper.get('${Endpoints.courses}/$courseId');

    return CourseResponseDto.fromJson(response.data['data']);
  }

  // get categories
  Future<List<String>> fetchCategories() async {
    final response = await _dioHelper.get('${Endpoints.courses}/category');

    return (response.data['data'] as List)
        .map((category) => category.toString())
        .toList();
  }
}
