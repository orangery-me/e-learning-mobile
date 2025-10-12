part of 'lectures_bloc.dart';

sealed class LecturesEvent extends Equatable {
  const LecturesEvent();

  @override
  List<Object> get props => [];
}

class LoadLecturesBySectionId extends LecturesEvent {
  final String sectionId;

  const LoadLecturesBySectionId(this.sectionId);

  @override
  List<Object> get props => [sectionId];
}

class LoadLecturesByCourseId extends LecturesEvent {
  final String courseId;

  const LoadLecturesByCourseId(this.courseId);

  @override
  List<Object> get props => [courseId];
}

class GetSelectedLecture extends LecturesEvent {
  final String lectureId;

  const GetSelectedLecture(this.lectureId);

  @override
  List<Object> get props => [lectureId];
}
