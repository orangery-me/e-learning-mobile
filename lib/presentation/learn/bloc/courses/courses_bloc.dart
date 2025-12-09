import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:e_learning_mobile/data/datasources/course/course_datasource.dart';
import 'package:e_learning_mobile/data/dtos/courses/course_with_instructor_info_response_dto.dart';
import 'package:e_learning_mobile/data/dtos/courses/course_response_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'courses_event.dart';
part 'courses_state.dart';

@injectable
class CoursesBloc extends Bloc<CoursesEvent, CoursesState> {
  final CourseDatasource datasource;

  CoursesBloc({required this.datasource}) : super(const CoursesState()) {
    on<LoadCourses>((event, emit) => loadCourses(event, emit));
    on<GetSelectedCourse>((event, emit) => getSelectedCourse(event, emit));
    on<LoadCategories>((event, emit) => loadCategories(event, emit));
  }

  Future<void> loadCourses(
      LoadCourses event, Emitter<CoursesState> emit) async {
    // Extract category if this is a category filter request
    String? categoryKey;
    if (event.filter != null && event.filter!.contains('category')) {
      categoryKey = _extractCategoryFromFilter(event.filter!);

      // Check if this category is already loading or loaded
      if (categoryKey != null) {
        if (state.loadingCategories.contains(categoryKey) ||
            state.categoryCourses.containsKey(categoryKey)) {
          // Already loading or loaded, skip
          return;
        }

        // Add to loading set
        final updatedLoadingCategories =
            Set<String>.from(state.loadingCategories);
        updatedLoadingCategories.add(categoryKey);
        emit(state.copyWith(
          loadingCategories: updatedLoadingCategories,
          errorMessage: null,
        ));
      } else {
        emit(state.copyWith(isLoading: true, errorMessage: null));
      }
    } else {
      // Logic for regular courses loading (including search)
      if (event.page != null && event.page! > 1) {
        // Appending (pagination) - keep loading state false for seamless scroll or use separate loading state
        // For simplicity, we keep isLoading false if appending, or maybe set a new state isAppending
      } else {
        emit(state.copyWith(isLoading: true, errorMessage: null));
      }
    }

    try {
      final courses = await datasource.fetchCourses(
          page: event.page,
          size: event.size,
          order: event.order,
          sortBy: event.sortBy,
          filter: event.filter,
          query: event.query);

      // If filter contains category, cache the results
      if (categoryKey != null) {
        final updatedCategoryCourses =
            Map<String, List<CourseWithInstructorInfoResponseDto>>.from(
                state.categoryCourses);
        updatedCategoryCourses[categoryKey] = courses;

        // Remove from loading set
        final updatedLoadingCategories =
            Set<String>.from(state.loadingCategories);
        updatedLoadingCategories.remove(categoryKey);

        emit(state.copyWith(
          categoryCourses: updatedCategoryCourses,
          loadingCategories: updatedLoadingCategories,
        ));
      } else {
        // Regular courses loading
        final isFirstPage = event.page == 1 || event.page == null;
        final updatedCourses =
            isFirstPage ? courses : [...state.courses, ...courses];
        final hasMore = courses.length >= (event.size ?? 10);

        emit(state.copyWith(
          courses: updatedCourses,
          isLoading: false,
          page: event.page ?? 1,
          hasMore: hasMore,
        ));
      }
    } catch (e) {
      log(e.toString());

      // Remove from loading set on error
      if (categoryKey != null) {
        final updatedLoadingCategories =
            Set<String>.from(state.loadingCategories);
        updatedLoadingCategories.remove(categoryKey);
        emit(state.copyWith(
          loadingCategories: updatedLoadingCategories,
          errorMessage: e.toString(),
        ));
      } else {
        emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      }
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
