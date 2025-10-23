import 'package:e_learning_mobile/data/datasources/code_exercise/remote/code_exercise_remote_datasource.dart';
import 'package:e_learning_mobile/data/dtos/code/problem_statement/code_problem_statement.dart';
import 'package:e_learning_mobile/data/dtos/code/submission/code_exercise_request_dto.dart';
import 'package:e_learning_mobile/data/dtos/code/judge_response/code_exercise_response_dto.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CodeExerciseDatasource {
  final CodeExerciseRemoteDatasource _remote;

  CodeExerciseDatasource({required CodeExerciseRemoteDatasource remote})
      : _remote = remote;

  Future<CodeExerciseResponseDto> executeCode(CodeExerciseRequestDto request) =>
      _remote.executeCode(request);

  Future<CodeProblemStatement> getProblemStatementById(String id) =>
      _remote.getProblemStatementById(id);
}
