import 'package:e_learning_mobile/data/datasources/course/remote/course_datasource.dart';
import 'package:e_learning_mobile/data/dtos/courses/course_with_instructor_info_response_dto.dart';
import 'package:e_learning_mobile/data/dtos/courses/course_response_dto.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CourseDatasource {
  final CourseRemoteDatasource _remoteDatasource;
  CourseDatasource({required CourseRemoteDatasource remoteDatasource})
      : _remoteDatasource = remoteDatasource;

  Future<List<CourseWithInstructorInfoResponseDto>> fetchCourses(
      {String? order,
      int? page,
      int? size,
      String? sortBy,
      String? filter,
      String? query}) async {
    return _remoteDatasource.fetchCourses(
        page: page,
        size: size,
        order: order,
        sortBy: sortBy,
        filter: filter,
        query: query);
  }

  Future<CourseResponseDto> fetchCourseById(String courseId) async {
    return _remoteDatasource.fetchCourseById(courseId);
  }

  Future<List<CourseResponseDto>> fetchCoursesByIds(
      List<String> courseIds) async {
    return _remoteDatasource.fetchCoursesByIds(courseIds);
  }

  Future<List<String>> fetchCategories() async {
    return _remoteDatasource.fetchCategories();
  }
}
