import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:e_learning_mobile/data/datasources/section/section_datasource.dart';
import 'package:e_learning_mobile/data/datasources/lecture/lecture_datasource.dart';
import 'package:e_learning_mobile/data/dtos/sections/section_response_dto.dart';
import 'package:e_learning_mobile/data/dtos/lectures/lecture_response_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'sections_event.dart';
part 'sections_state.dart';

@injectable
class SectionsBloc extends Bloc<SectionsEvent, SectionsState> {
  final SectionDatasource datasource;
  final LectureDatasource lectureDatasource;

  SectionsBloc({
    required this.datasource,
    required this.lectureDatasource,
  }) : super(SectionsState()) {
    on<LoadSectionsByCourseId>(
        (event, emit) => loadSectionsByCourseId(event, emit));
    on<GetSelectedSection>((event, emit) => getSelectedSection(event, emit));
  }

  Future<void> loadSectionsByCourseId(
      LoadSectionsByCourseId event, Emitter<SectionsState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      // Load both sections and lectures in parallel
      final futures = await Future.wait([
        datasource.fetchSectionsByCourseId(event.courseId),
        lectureDatasource.fetchLecturesByCourseId(event.courseId),
      ]);

      final sections = futures[0] as List<SectionResponseDto>;
      final lectures = futures[1] as List<LectureResponseDto>;

      emit(state.copyWith(
        sections: sections,
        lectures: lectures,
        isLoading: false,
      ));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> getSelectedSection(
      GetSelectedSection event, Emitter<SectionsState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final section = await datasource.fetchSectionById(event.sectionId);
      emit(state.copyWith(selectedSection: section, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
