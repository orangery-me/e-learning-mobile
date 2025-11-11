import 'package:e_learning_mobile/data/datasources/enrollment/remote/enrollment_remote_datasource.dart';
import 'package:e_learning_mobile/data/dtos/enrollment/enrollment_dto.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class EnrollmentDatasource {
  final EnrollmentRemoteDatasource _remoteDatasource;

  EnrollmentDatasource({required EnrollmentRemoteDatasource remoteDatasource})
      : _remoteDatasource = remoteDatasource;

  Future<List<EnrollmentDto>> getEnrollmentsByUserId(String userId) {
    return _remoteDatasource
        .getEnrollmentsByUserId(userId); // api: GET /enrollments/user/{userId}
  }

  Future<EnrollmentDto> getEnrollmentById(String enrollmentId) {
    return _remoteDatasource.getEnrollmentById(
        enrollmentId); // api: GET /enrollments/{enrollmentId}
  }
}
