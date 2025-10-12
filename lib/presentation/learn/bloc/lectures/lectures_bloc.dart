import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:e_learning_mobile/data/datasources/lecture/lecture_datasource.dart';
import 'package:e_learning_mobile/data/dtos/lectures/lecture_response_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'lectures_event.dart';
part 'lectures_state.dart';

@injectable
class LecturesBloc extends Bloc<LecturesEvent, LecturesState> {
  final LectureDatasource datasource;

  LecturesBloc({required this.datasource}) : super(LecturesState()) {
    on<LoadLecturesBySectionId>(
        (event, emit) => loadLecturesBySectionId(event, emit));
    on<LoadLecturesByCourseId>(
        (event, emit) => loadLecturesByCourseId(event, emit));
    on<GetSelectedLecture>((event, emit) => getSelectedLecture(event, emit));
  }

  Future<void> loadLecturesBySectionId(
      LoadLecturesBySectionId event, Emitter<LecturesState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final lectures =
          await datasource.fetchLecturesBySectionId(event.sectionId);
      emit(state.copyWith(lectures: lectures, isLoading: false));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> loadLecturesByCourseId(
      LoadLecturesByCourseId event, Emitter<LecturesState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final lectures = await datasource.fetchLecturesByCourseId(event.courseId);
      emit(state.copyWith(lectures: lectures, isLoading: false));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> getSelectedLecture(
      GetSelectedLecture event, Emitter<LecturesState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final lecture = await datasource.fetchLectureById(event.lectureId);
      emit(state.copyWith(selectedLecture: lecture, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
