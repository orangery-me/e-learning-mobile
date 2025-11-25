part of 'quizz_bloc.dart';

sealed class QuizzEvent extends Equatable {
  const QuizzEvent();

  @override
  List<Object?> get props => [];
}

class LoadQuizzByLectureId extends QuizzEvent {
  final String lectureId;

  const LoadQuizzByLectureId(this.lectureId);

  @override
  List<Object?> get props => [lectureId];
}

class LoadQuizzById extends QuizzEvent {
  final String quizzId;

  const LoadQuizzById(this.quizzId);

  @override
  List<Object?> get props => [quizzId];
}

class SubmitQuizz extends QuizzEvent {
  final QuizzSubmit submit;

  const SubmitQuizz(this.submit);

  @override
  List<Object?> get props => [submit];
}

class ResetQuizz extends QuizzEvent {
  const ResetQuizz();
}

class LoadUserAttempts extends QuizzEvent {
  final String quizzId;
  final String userId;

  const LoadUserAttempts(this.quizzId, this.userId);

  @override
  List<Object?> get props => [quizzId, userId];
}
