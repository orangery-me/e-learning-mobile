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
  final int positionSeconds;
  const UpdatePosition({required this.positionSeconds});
}

class TriggerEvents extends VideoPlayEvent {
  final List<VideoEvent> eventsToTrigger;
  const TriggerEvents({required this.eventsToTrigger});
}

// asking user to do the exercise
class AskToDoExercise extends VideoPlayEvent {
  final bool acceptToDoExercise;
  const AskToDoExercise({required this.acceptToDoExercise});
}
