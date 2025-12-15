import 'package:e_learning_mobile/data/datasources/roadmap/remote/roadmap_remote_datasource.dart';
import 'package:e_learning_mobile/data/dtos/roadmap/career_roadmap_request_dto.dart';
import 'package:e_learning_mobile/data/dtos/roadmap/career_roadmap_response_dto.dart';
import 'package:e_learning_mobile/data/dtos/roadmap/save_roadmap_request_dto.dart';
import 'package:e_learning_mobile/data/dtos/roadmap/save_roadmap_response_dto.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class RoadmapDatasource {
  final RoadmapRemoteDatasource _remoteDatasource;

  RoadmapDatasource({required RoadmapRemoteDatasource remoteDatasource})
      : _remoteDatasource = remoteDatasource;

  Future<CareerRoadmapResponseDto> generateRoadmap(
      CareerRoadmapRequestDto request) async {
    return await _remoteDatasource.generateRoadmap(request);
  }

  Future<SaveRoadmapResponseDto> saveRoadmap(
      SaveRoadmapRequestDto request) async {
    return await _remoteDatasource.saveRoadmap(request);
  }

  Future<SaveRoadmapResponseDto?> getExistingRoadmap() async {
    return await _remoteDatasource.getExistingRoadmap();
  }
}

