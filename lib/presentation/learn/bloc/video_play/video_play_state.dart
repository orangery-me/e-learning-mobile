part of 'video_play_bloc.dart';

class VideoPlayState extends Equatable {
  final List<VideoEvent> events; // All video events for the lecture
  final Set<String> triggeredIds; // IDs of events that have been triggered
  final List<VideoEvent> currentEvents; // Currently active event ID
  final VideoType? videoType; // Current video type
  // check if user accepts to do the exercise
  final bool acceptToDoExercise;
  final CodeProblemStatement?
      problemStatement; // problem statement for code event
  // quiz event state can be added here

  // Video player states
  final bool isLoading;
  final bool isDisposed;
  final String? currentVideoUrl;
  final String? selectedLectureId;
  final int lastLoggedTime;
  final bool isVideoInitialized;

  const VideoPlayState({
    this.events = const [],
    this.triggeredIds = const {},
    this.currentEvents = const [],
    this.acceptToDoExercise = false,
    this.videoType,
    this.problemStatement,
    this.isLoading = true,
    this.isDisposed = false,
    this.currentVideoUrl,
    this.selectedLectureId,
    this.lastLoggedTime = 0,
    this.isVideoInitialized = false,
  });

  VideoPlayState copyWith({
    List<VideoEvent>? events,
    Set<String>? triggeredIds,
    List<VideoEvent>? currentEvents,
    VideoType? videoType,
    bool? acceptToDoExercise,
    CodeProblemStatement? problemStatement,
    bool? isLoading,
    bool? isDisposed,
    String? currentVideoUrl,
    String? selectedLectureId,
    int? lastLoggedTime,
    bool? isVideoInitialized,
  }) {
    return VideoPlayState(
      events: events ?? this.events,
      triggeredIds: triggeredIds ?? this.triggeredIds,
      currentEvents: currentEvents ?? this.currentEvents,
      acceptToDoExercise: acceptToDoExercise ?? this.acceptToDoExercise,
      videoType: videoType ?? this.videoType,
      problemStatement: problemStatement ?? this.problemStatement,
      isLoading: isLoading ?? this.isLoading,
      isDisposed: isDisposed ?? this.isDisposed,
      currentVideoUrl: currentVideoUrl ?? this.currentVideoUrl,
      selectedLectureId: selectedLectureId ?? this.selectedLectureId,
      lastLoggedTime: lastLoggedTime ?? this.lastLoggedTime,
      isVideoInitialized: isVideoInitialized ?? this.isVideoInitialized,
    );
  }

  @override
  List<Object?> get props => [
        events,
        triggeredIds,
        currentEvents,
        acceptToDoExercise,
        videoType,
        problemStatement,
        isLoading,
        isDisposed,
        currentVideoUrl,
        selectedLectureId,
        lastLoggedTime,
        isVideoInitialized,
      ];
}
