import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:e_learning_mobile/data/datasources/roadmap/roadmap_datasource.dart';
import 'package:e_learning_mobile/data/datasources/course/course_datasource.dart';
import 'package:e_learning_mobile/data/dtos/roadmap/career_roadmap_request_dto.dart';
import 'package:e_learning_mobile/data/dtos/roadmap/career_roadmap_response_dto.dart';
import 'package:e_learning_mobile/data/dtos/roadmap/save_roadmap_request_dto.dart';
import 'package:e_learning_mobile/data/dtos/courses/course_response_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'roadmap_event.dart';
part 'roadmap_state.dart';

@injectable
class RoadmapBloc extends Bloc<RoadmapEvent, RoadmapState> {
  final RoadmapDatasource _datasource;
  final CourseDatasource _courseDatasource;

  RoadmapBloc({
    required RoadmapDatasource datasource,
    required CourseDatasource courseDatasource,
  })  : _datasource = datasource,
        _courseDatasource = courseDatasource,
        super(const RoadmapState()) {
    on<SubmitSurvey>(_onSubmitSurvey);
    on<UpdateSurveyAnswer>(_onUpdateSurveyAnswer);
    on<NavigateToNextQuestion>(_onNavigateToNextQuestion);
    on<NavigateToPreviousQuestion>(_onNavigateToPreviousQuestion);
    on<LoadSectionCourses>(_onLoadSectionCourses);
    on<SaveRoadmap>(_onSaveRoadmap);
    on<LoadExistingRoadmap>(_onLoadExistingRoadmap);
    on<ResetRoadmap>(_onResetRoadmap);
  }

  Future<void> _onSubmitSurvey(
    SubmitSurvey event,
    Emitter<RoadmapState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final request = CareerRoadmapRequestDto(
        role: event.answers['role'] ?? '',
        goal: event.answers['goal'] ?? '',
        answers: event.answers,
      );

      final roadmap = await _datasource.generateRoadmap(request);
      emit(state.copyWith(roadmap: roadmap, isLoading: false));
    } catch (e) {
      log('Error generating roadmap: $e');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onUpdateSurveyAnswer(
    UpdateSurveyAnswer event,
    Emitter<RoadmapState> emit,
  ) {
    final updatedAnswers = Map<String, String>.from(state.surveyAnswers);
    updatedAnswers[event.questionKey] = event.answer;
    emit(state.copyWith(surveyAnswers: updatedAnswers));
  }

  void _onNavigateToNextQuestion(
    NavigateToNextQuestion event,
    Emitter<RoadmapState> emit,
  ) {
    if (state.canGoToNextQuestion) {
      emit(
          state.copyWith(currentQuestionIndex: state.currentQuestionIndex + 1));
    }
  }

  void _onNavigateToPreviousQuestion(
    NavigateToPreviousQuestion event,
    Emitter<RoadmapState> emit,
  ) {
    if (state.canGoToPreviousQuestion) {
      emit(
          state.copyWith(currentQuestionIndex: state.currentQuestionIndex - 1));
    }
  }

  Future<void> _onLoadSectionCourses(
    LoadSectionCourses event,
    Emitter<RoadmapState> emit,
  ) async {
    // Check if already loaded
    if (state.sectionCourses.containsKey(event.sectionIndex)) {
      return;
    }

    // Set loading state
    final updatedLoadingStates =
        Map<String, bool>.from(state.sectionLoadingStates);
    updatedLoadingStates[event.sectionIndex] = true;
    emit(state.copyWith(sectionLoadingStates: updatedLoadingStates));

    try {
      final courses =
          await _courseDatasource.fetchCoursesByIds(event.courseIds);

      final updatedCourses =
          Map<String, List<CourseResponseDto>>.from(state.sectionCourses);
      updatedCourses[event.sectionIndex] = courses;

      final updatedLoadingStates2 =
          Map<String, bool>.from(state.sectionLoadingStates);
      updatedLoadingStates2[event.sectionIndex] = false;

      final updatedErrors = Map<String, String?>.from(state.sectionErrors);
      updatedErrors[event.sectionIndex] = null;

      emit(state.copyWith(
        sectionCourses: updatedCourses,
        sectionLoadingStates: updatedLoadingStates2,
        sectionErrors: updatedErrors,
      ));
    } catch (e) {
      log('Error loading section courses: $e');
      final updatedLoadingStates2 =
          Map<String, bool>.from(state.sectionLoadingStates);
      updatedLoadingStates2[event.sectionIndex] = false;

      final updatedErrors = Map<String, String?>.from(state.sectionErrors);
      updatedErrors[event.sectionIndex] = e.toString();

      emit(state.copyWith(
        sectionLoadingStates: updatedLoadingStates2,
        sectionErrors: updatedErrors,
      ));
    }
  }

  Future<void> _onSaveRoadmap(
    SaveRoadmap event,
    Emitter<RoadmapState> emit,
  ) async {
    if (state.roadmap == null) return;

    emit(state.copyWith(isSaving: true, errorMessage: null));

    try {
      final request = SaveRoadmapRequestDto(
        role: state.roadmap!.role,
        goal: state.roadmap!.goal,
        sections: state.roadmap!.sections,
        answers: state.surveyAnswers,
      );

      await _datasource.saveRoadmap(request);
      emit(state.copyWith(isSaving: false, isSaved: true));
    } catch (e) {
      log('Error saving roadmap: $e');
      emit(state.copyWith(
        isSaving: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLoadExistingRoadmap(
    LoadExistingRoadmap event,
    Emitter<RoadmapState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final savedRoadmap = await _datasource.getExistingRoadmap();
      if (savedRoadmap != null) {
        // Convert SaveRoadmapResponseDto to CareerRoadmapResponseDto
        final roadmap = CareerRoadmapResponseDto(
          role: savedRoadmap.role,
          goal: savedRoadmap.goal,
          sections: savedRoadmap.sections,
        );
        emit(state.copyWith(
          roadmap: roadmap,
          isLoading: false,
          surveyAnswers: savedRoadmap.answers,
        ));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      log('Error loading existing roadmap: $e');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onResetRoadmap(ResetRoadmap event, Emitter<RoadmapState> emit) {
    emit(const RoadmapState());
  }
}
