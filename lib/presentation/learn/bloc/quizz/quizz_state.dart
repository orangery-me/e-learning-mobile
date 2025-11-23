part of 'quizz_bloc.dart';

final class QuizzState extends Equatable {
  final QuizzOverviewDto? quizz;
  final QuizzResultDto? result;
  final bool isLoading;
  final String? errorMessage;

  const QuizzState({
    this.quizz,
    this.result,
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [quizz, result, isLoading, errorMessage];

  QuizzState copyWith({
    QuizzOverviewDto? quizz,
    QuizzResultDto? result,
    bool? isLoading,
    String? errorMessage,
  }) {
    return QuizzState(
      quizz: quizz ?? this.quizz,
      result: result ?? this.result,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
