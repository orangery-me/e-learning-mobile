part of 'roadmap_bloc.dart';

class RoadmapState extends Equatable {
  final CareerRoadmapResponseDto? roadmap;
  final bool isLoading;
  final String? errorMessage;
  final int currentQuestionIndex;
  final Map<String, String> surveyAnswers;
  final Map<String, List<CourseResponseDto>> sectionCourses;
  final Map<String, bool> sectionLoadingStates;
  final Map<String, String?> sectionErrors;
  final bool isSaving;
  final bool isSaved;

  const RoadmapState({
    this.roadmap,
    this.isLoading = false,
    this.errorMessage,
    this.currentQuestionIndex = 0,
    this.surveyAnswers = const {},
    this.sectionCourses = const {},
    this.sectionLoadingStates = const {},
    this.sectionErrors = const {},
    this.isSaving = false,
    this.isSaved = false,
  });

  RoadmapState copyWith({
    CareerRoadmapResponseDto? roadmap,
    bool? isLoading,
    String? errorMessage,
    int? currentQuestionIndex,
    Map<String, String>? surveyAnswers,
    Map<String, List<CourseResponseDto>>? sectionCourses,
    Map<String, bool>? sectionLoadingStates,
    Map<String, String?>? sectionErrors,
    bool? isSaving,
    bool? isSaved,
  }) {
    return RoadmapState(
      roadmap: roadmap ?? this.roadmap,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      surveyAnswers: surveyAnswers ?? this.surveyAnswers,
      sectionCourses: sectionCourses ?? this.sectionCourses,
      sectionLoadingStates: sectionLoadingStates ?? this.sectionLoadingStates,
      sectionErrors: sectionErrors ?? this.sectionErrors,
      isSaving: isSaving ?? this.isSaving,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  bool get canGoToNextQuestion {
    if (currentQuestionIndex >= 3) return false;
    final questionKeys = ['role', 'goal', 'experience', 'preferredStack'];
    final currentKey = questionKeys[currentQuestionIndex];
    return surveyAnswers.containsKey(currentKey) &&
        surveyAnswers[currentKey]!.isNotEmpty;
  }

  bool get canGoToPreviousQuestion => currentQuestionIndex > 0;

  bool get canSubmitSurvey {
    return surveyAnswers.containsKey('role') &&
        surveyAnswers.containsKey('goal') &&
        surveyAnswers.containsKey('experience') &&
        surveyAnswers.containsKey('preferredStack') &&
        surveyAnswers['role']!.isNotEmpty &&
        surveyAnswers['goal']!.isNotEmpty &&
        surveyAnswers['experience']!.isNotEmpty &&
        surveyAnswers['preferredStack']!.isNotEmpty;
  }

  @override
  List<Object?> get props => [
        roadmap,
        isLoading,
        errorMessage,
        currentQuestionIndex,
        surveyAnswers,
        sectionCourses,
        sectionLoadingStates,
        sectionErrors,
        isSaving,
        isSaved,
      ];
}
