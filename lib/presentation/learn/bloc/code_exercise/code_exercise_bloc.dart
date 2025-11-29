import 'dart:developer';

import 'package:e_learning_mobile/data/datasources/code_exercise/code_exercise_datasource.dart';
import 'package:e_learning_mobile/data/dtos/code/problem_statement/code_problem_statement.dart';
import 'package:e_learning_mobile/data/dtos/code/submission/code_exercise_request_dto.dart';
import 'package:e_learning_mobile/data/dtos/code/judge_response/code_exercise_response_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'code_exercise_event.dart';
part 'code_exercise_state.dart';

@injectable
class CodeExerciseBloc extends Bloc<CodeExerciseEvent, CodeExerciseState> {
  final CodeExerciseDatasource codeExerciseDatasource;

  CodeExerciseBloc({required this.codeExerciseDatasource})
      : super(CodeExerciseState()) {
    on<LoadProblemStatement>(_loadProblem);
    on<ExecuteCodeEvent>((event, emit) => executeCode(event, emit));
    on<ClearResult>((event, emit) =>
        emit(state.copyWith(result: null, errorMessage: null)));
  }

  Future<void> _loadProblem(
      LoadProblemStatement event, Emitter<CodeExerciseState> emit) async {
    emit(
      state.copyWith(
        isProblemLoading: true,
        problemErrorMessage: null,
      ),
    );
    try {
      final CodeProblemStatement problem =
          await codeExerciseDatasource.getProblemStatementById(event.problemId);
      emit(
        state.copyWith(
          problemStatement: problem,
          isProblemLoading: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isProblemLoading: false,
          problemErrorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> executeCode(
      ExecuteCodeEvent event, Emitter<CodeExerciseState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final request = CodeExerciseRequestDto(
        languageId: event.languageId,
        sourceCode: event.sourceCode,
        stdin: event.stdin,
        expectedOutput: event.expectedOutput,
        problemDescription: event.problemDescription,
      );
      log('Executing code with request: ${request.toJson()}');
      final result = await codeExerciseDatasource.executeCode(request);
      log('Executed code with result: $result');
      emit(state.copyWith(result: result, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
