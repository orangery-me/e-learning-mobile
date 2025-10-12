part of 'courses_bloc.dart';

sealed class CoursesEvent extends Equatable {
  const CoursesEvent();

  @override
  List<Object> get props => [];
}

class LoadCourses extends CoursesEvent {
  final int? page;
  final int? size;
  final String? order;
  final String? sortBy;
  final String? field;
  final String? query;

  const LoadCourses(
      {this.page, this.size, this.order, this.sortBy, this.field, this.query});
}

class GetSelectedCourse extends CoursesEvent {
  final String courseId;

  const GetSelectedCourse(this.courseId);

  @override
  List<Object> get props => [courseId];
}
