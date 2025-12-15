part of 'roadmap_bloc.dart';

sealed class RoadmapEvent extends Equatable {
  const RoadmapEvent();

  @override
  List<Object> get props => [];
}

class SubmitSurvey extends RoadmapEvent {
  final Map<String, String> answers;

  const SubmitSurvey(this.answers);

  @override
  List<Object> get props => [answers];
}

class UpdateSurveyAnswer extends RoadmapEvent {
  final String questionKey;
  final String answer;

  const UpdateSurveyAnswer(this.questionKey, this.answer);

  @override
  List<Object> get props => [questionKey, answer];
}

class NavigateToNextQuestion extends RoadmapEvent {
  const NavigateToNextQuestion();
}

class NavigateToPreviousQuestion extends RoadmapEvent {
  const NavigateToPreviousQuestion();
}

class LoadSectionCourses extends RoadmapEvent {
  final String sectionIndex;
  final List<String> courseIds;

  const LoadSectionCourses(this.sectionIndex, this.courseIds);

  @override
  List<Object> get props => [sectionIndex, courseIds];
}

class SaveRoadmap extends RoadmapEvent {
  const SaveRoadmap();
}

class LoadExistingRoadmap extends RoadmapEvent {
  const LoadExistingRoadmap();
}

class ResetRoadmap extends RoadmapEvent {
  const ResetRoadmap();
}
