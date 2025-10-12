import 'package:e_learning_mobile/common/constants/endpoints.dart';
import 'package:e_learning_mobile/common/helpers/dio_helper.dart';
import 'package:e_learning_mobile/data/dtos/courses/course_response_dto.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CourseRemoteDatasource {
  CourseRemoteDatasource({required DioHelper dioHelper})
      : _dioHelper = dioHelper;
  final DioHelper _dioHelper;

  Future<List<CourseResponseDto>> fetchCourses(
      {String? order = 'asc',
      int? page = 1,
      int? size = 10,
      String? sortBy = 'created_at'}) async {
    final response =
        await _dioHelper.get('${Endpoints.courses}/page', queryParameters: {
      if (page != null) 'page': page,
      if (size != null) 'paging': size,
      if (order != null) 'order': order,
      if (sortBy != null) 'sort_by': sortBy,
    });

    // Parse and return the list of courses from response
    return (response.data['data'] as List)
        .map((course) => CourseResponseDto.fromJson(course))
        .toList();
  }

  // get course by id
  Future<CourseResponseDto> fetchCourseById(String courseId) async {
    final response = await _dioHelper.get('${Endpoints.courses}/$courseId');

    return CourseResponseDto.fromJson(response.data['data']);
  }
}
