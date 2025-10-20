import 'dart:developer';

import 'package:e_learning_mobile/common/helpers/dio_helper.dart';
import 'package:e_learning_mobile/data/dtos/code/code_exercise_request_dto.dart';
import 'package:e_learning_mobile/data/dtos/code/code_exercise_response_dto.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CodeExerciseRemoteDatasource {
  final DioHelper _dioHelper;

  CodeExerciseRemoteDatasource({required DioHelper dioHelper})
      : _dioHelper = dioHelper;

  Future<CodeExerciseResponseDto> executeCode(
      CodeExerciseRequestDto request) async {
    log('Executing code with request DT 123O: ${request.toJson()}');
    // Determine endpoint based on whether problem description is provided (AI Judge mode)
    final endpoint = request.problemDescription != null &&
            request.problemDescription!.isNotEmpty
        ? 'https://judge-coursevo.onrender.com/api/judge/submit'
        : 'https://judge-coursevo.onrender.com/api/judge/test';

    final response = await _dioHelper.post(
      endpoint,
      data: request.toJson(),
    );

    log('Response from code execution API: ${response.data}');

    return CodeExerciseResponseDto.fromJson(response.data);
  }
}
