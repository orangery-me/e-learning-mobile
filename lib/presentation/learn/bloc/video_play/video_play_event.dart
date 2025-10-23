part of 'video_play_bloc.dart';

sealed class VideoPlayEvent extends Equatable {
  const VideoPlayEvent();

  @override
  List<Object?> get props => [];
}

class GetEventsByLectureId extends VideoPlayEvent {
  final String lectureId;

  const GetEventsByLectureId({required this.lectureId});

  @override
  List<Object> get props => [lectureId];
}

class SetEvents extends VideoPlayEvent {
  final List<VideoEvent> events;
  const SetEvents({required this.events});
}

enum VideoType { youtube, hosted }

class SetVideoType extends VideoPlayEvent {
  final VideoType videoType;
  const SetVideoType({required this.videoType});
}

class UpdatePosition extends VideoPlayEvent {
  final int currentPosition;
  const UpdatePosition({required this.currentPosition});
}

class TriggerEvents extends VideoPlayEvent {
  // final List<VideoEvent> eventsToTrigger;
  // const TriggerEvents({required this.eventsToTrigger});
}

// asking user to do the exercise
class AskToDoExercise extends VideoPlayEvent {
  final bool acceptToDoExercise;
  const AskToDoExercise({required this.acceptToDoExercise});
}

// Video initialization events
class InitializeVideo extends VideoPlayEvent {
  final String videoUrl;
  const InitializeVideo({required this.videoUrl});
}

class SelectLecture extends VideoPlayEvent {
  final String lectureId;
  final String videoUrl;
  const SelectLecture({required this.lectureId, required this.videoUrl});
}

class DisposeVideo extends VideoPlayEvent {
  const DisposeVideo();
}

class ResetVideoState extends VideoPlayEvent {
  const ResetVideoState();
}
