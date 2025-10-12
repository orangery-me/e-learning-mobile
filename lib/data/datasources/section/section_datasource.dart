import 'package:e_learning_mobile/data/datasources/section/remote/section_datasource.dart';
import 'package:e_learning_mobile/data/dtos/sections/section_response_dto.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SectionDatasource {
  final SectionRemoteDatasource _remoteDatasource;

  SectionDatasource({required SectionRemoteDatasource remoteDatasource})
      : _remoteDatasource = remoteDatasource;

  Future<List<SectionResponseDto>> fetchSectionsByCourseId(
      String courseId) async {
    return _remoteDatasource.fetchSectionsByCourseId(courseId);
  }

  Future<SectionResponseDto> fetchSectionById(String sectionId) async {
    return _remoteDatasource.fetchSectionById(sectionId);
  }
}
