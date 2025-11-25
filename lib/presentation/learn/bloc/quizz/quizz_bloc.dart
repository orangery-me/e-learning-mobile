import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:e_learning_mobile/data/datasources/quizz/quizz_datasource.dart';
import 'package:e_learning_mobile/data/dtos/quizz/quizz_overview_dto.dart';
import 'package:e_learning_mobile/data/dtos/quizz/quizz_result_dto.dart';
import 'package:e_learning_mobile/data/dtos/quizz/quizz_submit_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'quizz_event.dart';
part 'quizz_state.dart';

@injectable
class QuizzBloc extends Bloc<QuizzEvent, QuizzState> {
  final QuizzDatasource datasource;

  QuizzBloc({required this.datasource}) : super(const QuizzState()) {
    on<LoadQuizzByLectureId>(_loadQuizzByLectureId);
    on<LoadQuizzById>(_loadQuizzById);
    on<SubmitQuizz>(_submitQuiz);
    on<LoadUserAttempts>(_loadUserAttempts);
    on<ResetQuizz>(_resetQuizz);
  }

  Future<void> _loadQuizzByLectureId(
      LoadQuizzByLectureId event, Emitter<QuizzState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final quizz = await datasource.getQuizzByLectureId(event.lectureId);
      emit(state.copyWith(quizz: quizz, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _loadQuizzById(
      LoadQuizzById event, Emitter<QuizzState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final quizz = await datasource.getQuizzById(event.quizzId);
      emit(state.copyWith(quizz: quizz, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _submitQuiz(SubmitQuizz event, Emitter<QuizzState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final result = await datasource.submitQuizzAnswers(event.submit);
      emit(state.copyWith(result: result, isLoading: false));
    } catch (e) {
      log('submit quizz error: $e');
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _loadUserAttempts(
      LoadUserAttempts event, Emitter<QuizzState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final attempts = await datasource.getUserAttemptsByQuizzId(
          event.quizzId, event.userId);
      emit(state.copyWith(attempts: attempts, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  void _resetQuizz(ResetQuizz event, Emitter<QuizzState> emit) {
    emit(const QuizzState());
  }
}
