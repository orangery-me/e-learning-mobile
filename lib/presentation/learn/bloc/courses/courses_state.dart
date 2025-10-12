part of 'courses_bloc.dart';

final class CoursesState extends Equatable {
  final List<CourseResponseDto> courses;
  final CourseResponseDto? selectedCourse;
  final bool isLoading;
  final String? errorMessage;

  const CoursesState({
    this.courses = const [],
    this.selectedCourse,
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [courses, selectedCourse, isLoading, errorMessage];

  CoursesState copyWith({
    List<CourseResponseDto>? courses,
    CourseResponseDto? selectedCourse,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CoursesState(
      courses: courses ?? this.courses,
      selectedCourse: selectedCourse ?? this.selectedCourse,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
