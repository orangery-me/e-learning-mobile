import 'package:e_learning_mobile/data/datasources/course/remote/course_datasource.dart';
import 'package:e_learning_mobile/data/dtos/courses/course_response_dto.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CourseDatasource {
  final CourseRemoteDatasource _remoteDatasource;
  CourseDatasource({required CourseRemoteDatasource remoteDatasource})
      : _remoteDatasource = remoteDatasource;

  Future<List<CourseResponseDto>> fetchCourses(
      {String? order, int? page, int? size, String? sortBy}) async {
    return _remoteDatasource.fetchCourses(
        page: page, size: size, order: order, sortBy: sortBy);
  }

  Future<CourseResponseDto> fetchCourseById(String courseId) async {
    return _remoteDatasource.fetchCourseById(courseId);
  }
}
