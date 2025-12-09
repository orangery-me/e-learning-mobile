part of 'courses_bloc.dart';

final class CoursesState extends Equatable {
  final List<CourseWithInstructorInfoResponseDto> courses;
  final CourseResponseDto? selectedCourse;
  final List<String> categories;
  final Map<String, List<CourseWithInstructorInfoResponseDto>?> categoryCourses;
  final bool isLoading;
  final Set<String>
      loadingCategories; // Track which categories are currently loading
  final String? errorMessage;
  final int page;
  final bool hasMore;

  const CoursesState({
    this.courses = const [],
    this.selectedCourse,
    this.categories = const [],
    this.categoryCourses = const {},
    this.isLoading = false,
    this.loadingCategories = const {},
    this.errorMessage,
    this.page = 1,
    this.hasMore = true,
  });

  @override
  List<Object?> get props => [
        courses,
        selectedCourse,
        categories,
        categoryCourses,
        isLoading,
        loadingCategories,
        errorMessage,
        page,
        hasMore,
      ];

  CoursesState copyWith({
    List<CourseWithInstructorInfoResponseDto>? courses,
    CourseResponseDto? selectedCourse,
    List<String>? categories,
    Map<String, List<CourseWithInstructorInfoResponseDto>>? categoryCourses,
    bool? isLoading,
    Set<String>? loadingCategories,
    String? errorMessage,
    int? page,
    bool? hasMore,
  }) {
    return CoursesState(
      courses: courses ?? this.courses,
      selectedCourse: selectedCourse ?? this.selectedCourse,
      categories: categories ?? this.categories,
      categoryCourses: categoryCourses ?? this.categoryCourses,
      isLoading: isLoading ?? this.isLoading,
      loadingCategories: loadingCategories ?? this.loadingCategories,
      errorMessage: errorMessage ?? this.errorMessage,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  // Helper methods
  List<CourseWithInstructorInfoResponseDto>? getCoursesForCategory(
      String category) {
    return categoryCourses[category];
  }

  bool isCategoryLoading(String category) {
    return loadingCategories.contains(category);
  }
}
