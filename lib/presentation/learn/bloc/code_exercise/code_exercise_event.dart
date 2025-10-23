part of 'code_exercise_bloc.dart';

sealed class CodeExerciseEvent extends Equatable {
  const CodeExerciseEvent();

  @override
  List<Object> get props => [];
}

class ExecuteCodeEvent extends CodeExerciseEvent {
  final String sourceCode;
  final int languageId;
  final String? stdin;
  final String? expectedOutput;
  final String? problemDescription;

  const ExecuteCodeEvent({
    required this.sourceCode,
    required this.languageId,
    this.stdin,
    this.expectedOutput,
    this.problemDescription,
  });
}

class ClearResult extends CodeExerciseEvent {}

// class GetCodeExercise