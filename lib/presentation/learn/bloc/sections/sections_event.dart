part of 'sections_bloc.dart';

sealed class SectionsEvent extends Equatable {
  const SectionsEvent();

  @override
  List<Object> get props => [];
}

class LoadSectionsByCourseId extends SectionsEvent {
  final String courseId;

  const LoadSectionsByCourseId(this.courseId);

  @override
  List<Object> get props => [courseId];
}

class GetSelectedSection extends SectionsEvent {
  final String sectionId;

  const GetSelectedSection(this.sectionId);

  @override
  List<Object> get props => [sectionId];
}
