part of 'code_exercise_bloc.dart';

const _noChange = Object();

final class CodeExerciseState extends Equatable {
  final CodeExerciseResponseDto? result;
  final CodeProblemStatement? problemStatement;
  final bool isLoading;
  final bool isProblemLoading;
  final String? errorMessage;
  final String? problemErrorMessage;

  const CodeExerciseState({
    this.result,
    this.problemStatement,
    this.isLoading = false,
    this.isProblemLoading = false,
    this.errorMessage,
    this.problemErrorMessage,
  });

  CodeExerciseState copyWith({
    Object? result = _noChange,
    Object? problemStatement = _noChange,
    bool? isLoading,
    bool? isProblemLoading,
    Object? errorMessage = _noChange,
    Object? problemErrorMessage = _noChange,
  }) {
    return CodeExerciseState(
      result: identical(result, _noChange)
          ? this.result
          : result as CodeExerciseResponseDto?,
      problemStatement: identical(problemStatement, _noChange)
          ? this.problemStatement
          : problemStatement as CodeProblemStatement?,
      isLoading: isLoading ?? this.isLoading,
      isProblemLoading: isProblemLoading ?? this.isProblemLoading,
      errorMessage: identical(errorMessage, _noChange)
          ? this.errorMessage
          : errorMessage as String?,
      problemErrorMessage: identical(problemErrorMessage, _noChange)
          ? this.problemErrorMessage
          : problemErrorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
        result,
        problemStatement,
        isLoading,
        isProblemLoading,
        errorMessage,
        problemErrorMessage,
      ];
}
