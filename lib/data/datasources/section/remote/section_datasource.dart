import 'package:e_learning_mobile/common/constants/endpoints.dart';
import 'package:e_learning_mobile/common/helpers/dio_helper.dart';
import 'package:e_learning_mobile/data/dtos/sections/section_response_dto.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SectionRemoteDatasource {
  final DioHelper _dioHelper;

  SectionRemoteDatasource({required DioHelper dioHelper})
      : _dioHelper = dioHelper;

  Future<List<SectionResponseDto>> fetchSectionsByCourseId(
      String courseId) async {
    final response =
        await _dioHelper.get('${Endpoints.courses}/$courseId/sections');

    final List<dynamic> sectionsJson = response.data['data'] ?? response.data;
    return sectionsJson
        .map((json) => SectionResponseDto.fromJson(json))
        .toList();
  }

  Future<SectionResponseDto> fetchSectionById(String sectionId) async {
    final response = await _dioHelper.get('${Endpoints.sections}/$sectionId');

    return SectionResponseDto.fromJson(response.data['data'] ?? response.data);
  }
}
