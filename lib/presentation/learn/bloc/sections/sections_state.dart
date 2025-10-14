part of 'sections_bloc.dart';

final class SectionsState extends Equatable {
  final List<SectionResponseDto> sections;
  final SectionResponseDto? selectedSection;
  final Map<String, List<LectureResponseDto>> lecturesCache;
  final Set<String> loadingSectionIds;
  final String? errorMessage;

  const SectionsState({
    this.sections = const [],
    this.selectedSection,
    this.lecturesCache = const {},
    this.loadingSectionIds = const {},
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        sections,
        selectedSection,
        lecturesCache,
        loadingSectionIds,
        errorMessage
      ];

  SectionsState copyWith({
    List<SectionResponseDto>? sections,
    SectionResponseDto? selectedSection,
    Map<String, List<LectureResponseDto>>? lecturesCache,
    Set<String>? loadingSectionIds,
    String? errorMessage,
  }) {
    return SectionsState(
      sections: sections ?? this.sections,
      selectedSection: selectedSection ?? this.selectedSection,
      lecturesCache: lecturesCache ?? this.lecturesCache,
      loadingSectionIds: loadingSectionIds ?? this.loadingSectionIds,
      errorMessage: errorMessage,
    );
  }

  // Helper method to get lectures for a specific section
  List<LectureResponseDto> getLecturesForSection(String sectionId) {
    return lecturesCache[sectionId] ?? [];
  }

  // Helper method to check if a section is currently loading
  bool isSectionLoading(String sectionId) {
    return loadingSectionIds.contains(sectionId);
  }
}
