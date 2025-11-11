import 'dart:developer';

import 'package:e_learning_mobile/common/constants/endpoints.dart';
import 'package:e_learning_mobile/common/helpers/dio_helper.dart';
import 'package:e_learning_mobile/data/dtos/enrollment/enrollment_dto.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class EnrollmentRemoteDatasource {
  EnrollmentRemoteDatasource({required DioHelper dioHelper})
      : _dioHelper = dioHelper;
  final DioHelper _dioHelper;

  Future<List<EnrollmentDto>> getEnrollmentsByUserId(String userId) async {
    try {
      final response = await _dioHelper.get(
        '${Endpoints.enrollments}/user/$userId',
      );
      log('Fetched enrollments by userId: ${response.data}');

      // Parse and return the list of enrollments from response
      return (response.data as List)
          .map((enrollment) => EnrollmentDto.fromJson(enrollment))
          .toList();
    } catch (e) {
      log('Error fetching enrollments by userId: $e');
      rethrow;
    }
  }

  Future<EnrollmentDto> getEnrollmentById(String enrollmentId) async {
    try {
      final response =
          await _dioHelper.get('${Endpoints.enrollments}/$enrollmentId');
      log('Fetched enrollment by id: ${response.data}');

      return EnrollmentDto.fromJson(response.data['data']);
    } catch (e) {
      log('Error fetching enrollment by id: $e');
      rethrow;
    }
  }
}
