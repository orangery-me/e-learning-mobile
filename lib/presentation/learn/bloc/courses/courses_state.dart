part of 'courses_bloc.dart';

final class CoursesState extends Equatable {
  final List<CourseModel> courses;
  final bool isLoading;
  final String? errorMessage;

  const CoursesState({
    this.courses = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [courses, isLoading, errorMessage];

  CoursesState copyWith({
    List<CourseModel>? courses,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CoursesState(
      courses: courses ?? this.courses,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
