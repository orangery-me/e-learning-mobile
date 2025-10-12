import 'package:e_learning_mobile/common/constants/endpoints.dart';
import 'package:e_learning_mobile/common/helpers/dio_helper.dart';
import 'package:e_learning_mobile/data/dtos/lectures/lecture_response_dto.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class LectureRemoteDatasource {
  final DioHelper _dioHelper;

  LectureRemoteDatasource({required DioHelper dioHelper})
      : _dioHelper = dioHelper;

  Future<List<LectureResponseDto>> fetchLecturesBySectionId(
      String sectionId) async {
    final response =
        await _dioHelper.get('${Endpoints.sections}/$sectionId/lectures');

    final List<dynamic> lecturesJson = response.data['data'] ?? response.data;
    return lecturesJson
        .map((json) => LectureResponseDto.fromJson(json))
        .toList();
  }

  // (thừa)
  Future<List<LectureResponseDto>> fetchLecturesByCourseId(
      String courseId) async {
    final response =
        await _dioHelper.get('${Endpoints.courses}/$courseId/lectures');

    final List<dynamic> lecturesJson = response.data['data'] ?? response.data;
    return lecturesJson
        .map((json) => LectureResponseDto.fromJson(json))
        .toList();
  }

  Future<LectureResponseDto> fetchLectureById(String lectureId) async {
    final response = await _dioHelper.get('${Endpoints.lectures}/$lectureId');

    return LectureResponseDto.fromJson(response.data['data'] ?? response.data);
  }
}
