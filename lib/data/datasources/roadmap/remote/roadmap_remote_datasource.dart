import 'dart:developer';

import 'package:e_learning_mobile/common/constants/endpoints.dart';
import 'package:e_learning_mobile/common/helpers/dio_helper.dart';
import 'package:e_learning_mobile/data/dtos/roadmap/career_roadmap_request_dto.dart';
import 'package:e_learning_mobile/data/dtos/roadmap/career_roadmap_response_dto.dart';
import 'package:e_learning_mobile/data/dtos/roadmap/save_roadmap_request_dto.dart';
import 'package:e_learning_mobile/data/dtos/roadmap/save_roadmap_response_dto.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class RoadmapRemoteDatasource {
  RoadmapRemoteDatasource({required DioHelper dioHelper})
      : _dioHelper = dioHelper;
  final DioHelper _dioHelper;

  Future<CareerRoadmapResponseDto> generateRoadmap(
      CareerRoadmapRequestDto request) async {
    log('Generating roadmap with data: ${request.toJson()}');
    final response = await _dioHelper.post(
      'https://judge-coursevo.onrender.com/api/career/generate',
      data: request.toJson(),
    );
    log('Roadmap response: ${response.data}');

    if (response.data['status'] == 'success') {
      return CareerRoadmapResponseDto.fromJson(
          response.data['data'] as Map<String, dynamic>);
    } else {
      throw Exception('Failed to generate roadmap: ${response.data}');
    }
  }

  Future<SaveRoadmapResponseDto> saveRoadmap(
      SaveRoadmapRequestDto request) async {
    log('Saving roadmap with data: ${request.toJson()}');
    final response = await _dioHelper.post(
      Endpoints.careerPlans,
      data: request.toJson(),
    );
    log('Save roadmap response: ${response.data}');

    if (response.data['status'] == 'success') {
      return SaveRoadmapResponseDto.fromJson(
          response.data['data'] as Map<String, dynamic>);
    } else {
      throw Exception('Failed to save roadmap: ${response.data}');
    }
  }

  Future<SaveRoadmapResponseDto?> getExistingRoadmap() async {
    try {
      log('Fetching existing roadmap');
      final response = await _dioHelper.get(Endpoints.careerPlans);
      log('Get roadmap response: ${response.data}');

      if (response.data['status'] == 'success' &&
          response.data['data'] != null) {
        return SaveRoadmapResponseDto.fromJson(
            response.data['data'] as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      log('No existing roadmap found or error: $e');
      return null;
    }
  }
}

