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

class LoadLecturesBySectionId extends SectionsEvent {
  final String sectionId;

  const LoadLecturesBySectionId(this.sectionId);

  @override
  List<Object> get props => [sectionId];
}

class SelectSection extends SectionsEvent {
  final String sectionId;
  const SelectSection(this.sectionId);
}

class DeselectSection extends SectionsEvent {
  final String sectionId;
  const DeselectSection(this.sectionId);
}

