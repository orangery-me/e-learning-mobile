part of 'courses_bloc.dart';

final class CoursesState extends Equatable {
  final List<CourseResponseDto> courses;
  final CourseResponseDto? selectedCourse;
  final List<String> categories;
  final Map<String, List<CourseResponseDto>?> categoryCourses;
  final bool isLoading;
  final String? errorMessage;

  const CoursesState({
    this.courses = const [],
    this.selectedCourse,
    this.categories = const [],
    this.categoryCourses = const {},
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        courses,
        selectedCourse,
        categories,
        categoryCourses,
        isLoading,
        errorMessage
      ];

  CoursesState copyWith({
    List<CourseResponseDto>? courses,
    CourseResponseDto? selectedCourse,
    List<String>? categories,
    Map<String, List<CourseResponseDto>>? categoryCourses,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CoursesState(
      courses: courses ?? this.courses,
      selectedCourse: selectedCourse ?? this.selectedCourse,
      categories: categories ?? this.categories,
      categoryCourses: categoryCourses ?? this.categoryCourses,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  // Helper methods
  List<CourseResponseDto>? getCoursesForCategory(String category) {
    return categoryCourses[category];
  }
}
