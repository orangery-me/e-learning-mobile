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
  }

  Future<void> loadCourses(
      LoadCourses event, Emitter<CoursesState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final courses = await datasource.fetchCourses(
          page: event.page,
          size: event.size,
          order: event.order,
          sortBy: event.sortBy);
      emit(state.copyWith(courses: courses, isLoading: false));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
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
}
