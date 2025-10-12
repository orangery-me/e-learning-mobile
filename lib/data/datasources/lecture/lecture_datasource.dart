import 'package:e_learning_mobile/data/datasources/lecture/remote/lecture_datasource.dart';
import 'package:e_learning_mobile/data/dtos/lectures/lecture_response_dto.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class LectureDatasource {
  final LectureRemoteDatasource _remoteDatasource;

  LectureDatasource({required LectureRemoteDatasource remoteDatasource})
      : _remoteDatasource = remoteDatasource;

  Future<List<LectureResponseDto>> fetchLecturesBySectionId(
      String sectionId) async {
    return _remoteDatasource.fetchLecturesBySectionId(sectionId);
  }

  Future<List<LectureResponseDto>> fetchLecturesByCourseId(
      String courseId) async {
    return _remoteDatasource.fetchLecturesByCourseId(courseId);
  }

  Future<LectureResponseDto> fetchLectureById(String lectureId) async {
    return _remoteDatasource.fetchLectureById(lectureId);
  }
}
