part of 'lectures_bloc.dart';

final class LecturesState extends Equatable {
  final List<LectureResponseDto> lectures;
  final LectureResponseDto? selectedLecture;
  final bool isLoading;
  final String? errorMessage;

  const LecturesState({
    this.lectures = const [],
    this.selectedLecture,
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  List<Object?> get props =>
      [lectures, selectedLecture, isLoading, errorMessage];

  LecturesState copyWith({
    List<LectureResponseDto>? lectures,
    LectureResponseDto? selectedLecture,
    bool? isLoading,
    String? errorMessage,
  }) {
    return LecturesState(
      lectures: lectures ?? this.lectures,
      selectedLecture: selectedLecture ?? this.selectedLecture,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
