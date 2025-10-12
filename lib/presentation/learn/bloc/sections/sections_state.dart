part of 'sections_bloc.dart';

final class SectionsState extends Equatable {
  final List<SectionResponseDto> sections;
  final SectionResponseDto? selectedSection;
  final List<LectureResponseDto> lectures;
  final bool isLoading;
  final String? errorMessage;

  const SectionsState({
    this.sections = const [],
    this.selectedSection,
    this.lectures = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  List<Object?> get props =>
      [sections, selectedSection, lectures, isLoading, errorMessage];

  SectionsState copyWith({
    List<SectionResponseDto>? sections,
    SectionResponseDto? selectedSection,
    List<LectureResponseDto>? lectures,
    bool? isLoading,
    String? errorMessage,
  }) {
    return SectionsState(
      sections: sections ?? this.sections,
      selectedSection: selectedSection ?? this.selectedSection,
      lectures: lectures ?? this.lectures,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
