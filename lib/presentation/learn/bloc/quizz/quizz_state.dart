part of 'quizz_bloc.dart';

final class QuizzState extends Equatable {
  final QuizzOverviewDto? quizz;
  final QuizzResultDto? result;
  final List<QuizzResultDto>? attempts;
  final bool isLoading;
  final String? errorMessage;

  const QuizzState({
    this.quizz,
    this.result,
    this.attempts,
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [quizz, result, attempts, isLoading, errorMessage];

  QuizzState copyWith({
    QuizzOverviewDto? quizz,
    QuizzResultDto? result,
    List<QuizzResultDto>? attempts,
    bool? isLoading,
    String? errorMessage, 
  }) {
    return QuizzState(
      quizz: quizz ?? this.quizz,
      result: result ?? this.result,
      attempts: attempts ?? this.attempts,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
