import 'dart:developer';

import 'package:e_learning_mobile/common/constants/endpoints.dart';
import 'package:e_learning_mobile/common/helpers/dio_helper.dart';
import 'package:e_learning_mobile/data/dtos/code/problem_statement/code_problem_statement.dart';
import 'package:e_learning_mobile/data/dtos/code/submission/code_exercise_request_dto.dart';
import 'package:e_learning_mobile/data/dtos/code/judge_response/code_exercise_response_dto.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CodeExerciseRemoteDatasource {
  final DioHelper _dioHelper;

  CodeExerciseRemoteDatasource({required DioHelper dioHelper})
      : _dioHelper = dioHelper;

  Future<CodeExerciseResponseDto> executeCode(
      CodeExerciseRequestDto request) async {
    final response = await _dioHelper.post(
      'https://judge-coursevo.onrender.com/api/judge/test',
      data: request.toJson(),
    );

    return CodeExerciseResponseDto.fromJson(response.data);
  }

  Future<CodeExerciseResponseDto> submitCode(
      CodeExerciseRequestDto request) async {
    log('Submitting code with request: ${request.toJson()}');
    final response = await _dioHelper.post(
      'https://judge-coursevo.onrender.com/api/judge/submit',
      data: request.toJson(),
    );

    return CodeExerciseResponseDto.fromJson(response.data);
  }

  Future<CodeProblemStatement> getProblemStatementById(String id) async {
    final response = await _dioHelper.get('${Endpoints.codeExercises}/$id');
    log('Fetched problem statement data: ${response.data}');
    return CodeProblemStatement.fromJson(response.data['data']);
  }
}
