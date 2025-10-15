import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:e_learning_mobile/data/datasources/course/course_datasource.dart';
import 'package:e_learning_mobile/data/dtos/courses/course_response_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'courses_event.dart';
part 'courses_state.dart';

@injectable
class CoursesBloc extends Bloc<CoursesEvent, CoursesState> {
  final CourseDatasource datasource;

  CoursesBloc({required this.datasource}) : super(CoursesState()) {
    on<LoadCourses>((event, emit) => loadCourses(event, emit));
    on<GetSelectedCourse>((event, emit) => getSelectedCourse(event, emit));
    on<LoadCategories>((event, emit) => loadCategories(event, emit));
  }

  Future<void> loadCourses(
      LoadCourses event, Emitter<CoursesState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final courses = await datasource.fetchCourses(
          page: event.page,
          size: event.size,
          order: event.order,
          sortBy: event.sortBy,
          filter: event.filter);

      // If filter contains category, cache the results
      if (event.filter != null && event.filter!.contains('category')) {
        final updatedCategoryCourses =
            Map<String, List<CourseResponseDto>>.from(state.categoryCourses);
        // Extract category from filter for caching key
        final categoryKey =
            _extractCategoryFromFilter(event.filter!) ?? 'DEVELOPMENT';

        updatedCategoryCourses[categoryKey] = courses;

        emit(state.copyWith(
          categoryCourses: updatedCategoryCourses,
          isLoading: false,
        ));
      } else {
        // Regular courses loading
        emit(state.copyWith(courses: courses, isLoading: false));
      }
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  // Helper method to extract category from filter
  String? _extractCategoryFromFilter(String filter) {
    final categoryMatch =
        RegExp(r"category in \('([^']+)'\)").firstMatch(filter);
    return categoryMatch?.group(1);
  }

  Future<void> getSelectedCourse(
      GetSelectedCourse event, Emitter<CoursesState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      // Fetch the course by event.courseId
      // emit(state.copyWith(selectedCourse: fetchedCourse, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> loadCategories(
      LoadCategories event, Emitter<CoursesState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final categories = await datasource.fetchCategories();
      emit(state.copyWith(categories: categories, isLoading: false));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
