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
    on<LoadLecturesBySectionId>(
        (event, emit) => loadLecturesBySectionId(event, emit));
    on<SelectSection>((event, emit) => _selectSection(event, emit));
    on<DeselectSection>((event, emit) => _deselectSection(event, emit));
  }

  Future<void> loadSectionsByCourseId(
      LoadSectionsByCourseId event, Emitter<SectionsState> emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      // Load only sections
      final sections = await datasource.fetchSectionsByCourseId(event.courseId);

      emit(state.copyWith(
        isLoading: false,
        sections: sections,
      ));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  Future<void> loadLecturesBySectionId(
      LoadLecturesBySectionId event, Emitter<SectionsState> emit) async {
    // Check if lectures are already cached for this section
    if (state.lecturesCache.containsKey(event.sectionId)) {
      return; // Lectures already cached, no need to fetch again
    }

    // Check if this section is already loading
    if (state.isSectionLoading(event.sectionId)) {
      return; // Already loading, avoid duplicate requests
    }

    // Add section ID to loading set
    final updatedLoadingIds = Set<String>.from(state.loadingSectionIds)
      ..add(event.sectionId);
    emit(state.copyWith(
      loadingSectionIds: updatedLoadingIds,
      errorMessage: null,
    ));

    try {
      emit(state.copyWith(isLoading: true));
      // Fetch lectures for the section
      final lectures =
          await lectureDatasource.fetchLecturesBySectionId(event.sectionId);

      // Update cache with new lectures
      final updatedCache =
          Map<String, List<LectureResponseDto>>.from(state.lecturesCache);
      updatedCache[event.sectionId] = lectures;

      // Remove section ID from loading set
      final finalLoadingIds = Set<String>.from(state.loadingSectionIds)
        ..remove(event.sectionId);

      emit(state.copyWith(
        isLoading: false,
        lecturesCache: updatedCache,
        loadingSectionIds: finalLoadingIds,
      ));
    } catch (e) {
      log(e.toString());

      // Remove section ID from loading set on error
      final finalLoadingIds = Set<String>.from(state.loadingSectionIds)
        ..remove(event.sectionId);

      emit(state.copyWith(
        isLoading: false,
        loadingSectionIds: finalLoadingIds,
        errorMessage: e.toString(),
      ));
    }
  }

  void _selectSection(SelectSection event, Emitter<SectionsState> emit) {
    if (state.sections.isEmpty) {
      return;
    }
    final selectedSection = state.sections.firstWhere(
        (section) => section.sectionId == event.sectionId,
        orElse: () => state.sections[0]);

    log('bbb Selected section: ${selectedSection.toJson()}');
    emit(state.copyWith(
        selectedSection: [...state.selectedSection, selectedSection]));
  }

  void _deselectSection(DeselectSection event, Emitter<SectionsState> emit) {
    final updatedSelectedSections = state.selectedSection
        .where((section) => section.sectionId != event.sectionId)
        .toList();

    emit(state.copyWith(selectedSection: updatedSelectedSections));
  }
}
