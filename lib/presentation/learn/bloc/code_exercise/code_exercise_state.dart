part of 'code_exercise_bloc.dart';

final class CodeExerciseState extends Equatable {
  final CodeExerciseResponseDto? result;
  // final CodeProblemStatement? problemStatement;
  final bool isLoading;
  final String? errorMessage;

  const CodeExerciseState({
    this.result,
    this.isLoading = false,
    this.errorMessage,
  });

  CodeExerciseState copyWith({
    CodeExerciseResponseDto? result,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CodeExerciseState(
      result: result ?? this.result,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [result, isLoading, errorMessage];
}
