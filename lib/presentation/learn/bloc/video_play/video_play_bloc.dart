import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chewie/chewie.dart';
import 'package:e_learning_mobile/data/datasources/code_exercise/code_exercise_datasource.dart';
import 'package:e_learning_mobile/data/datasources/video_events/video_events_datasource.dart';
import 'package:e_learning_mobile/data/dtos/code/problem_statement/code_problem_statement.dart';
import 'package:e_learning_mobile/data/dtos/video_event/video_event.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

part 'video_play_event.dart';
part 'video_play_state.dart';

@injectable
class VideoPlayBloc extends Bloc<VideoPlayEvent, VideoPlayState> {
  final VideoEventsDatasource videoEventsDatasource;
  final CodeExerciseDatasource codeExerciseDatasource;

  // Video controllers
  YoutubePlayerController? _youtubeController;
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  VideoPlayBloc(this.videoEventsDatasource, this.codeExerciseDatasource)
      : super(const VideoPlayState()) {
    on<GetEventsByLectureId>(_onGetEventsByLectureId);
    on<TriggerEvents>(_triggerEvent);
    on<AskToDoExercise>((event, emit) =>
        emit(state.copyWith(acceptToDoExercise: event.acceptToDoExercise)));
    on<UpdatePosition>(_onVideoPositionChanged);
    on<SetVideoType>(_onSetVideoType);
    on<InitializeVideo>(_onInitializeVideo);
    on<SelectLecture>(_onSelectLecture);
    on<DisposeVideo>(_onDisposeVideo);
    on<ResetVideoState>(_onResetVideoState);
  }

  Future<void> _onGetEventsByLectureId(
      GetEventsByLectureId event, Emitter<VideoPlayState> emit) async {
    try {
      final events = await videoEventsDatasource
          .fetchVideoEventsByLectureId(event.lectureId);
      log('Fetched video events: $events');

      emit(state.copyWith(events: events));
    } catch (e) {
      log('Error fetching video events: $e');
      emit(state.copyWith(events: []));
    }
  }

  void _onSetVideoType(SetVideoType event, Emitter<VideoPlayState> emit) {
    emit(state.copyWith(videoType: event.videoType));
  }

  Future<void> _triggerEvent(
      TriggerEvents event, Emitter<VideoPlayState> emit) async {
    final triggered = <VideoEvent>{};

    for (final e in state.events) {
      // Check if this event should be triggered at the current position and not already triggered
      if (state.lastLoggedTime == e.triggerTime &&
          !state.triggeredIds.contains(e.id)) {
        // Mark this event as triggered
        triggered.add(e);
        log('Triggering event ${e.eventType} at ${state.lastLoggedTime}s');
      }
    }

    if (triggered.isNotEmpty) {
      final updated = {...state.triggeredIds, ...triggered.map((e) => e.id)};
      final currentEvents = triggered.toList();

      emit(state.copyWith(triggeredIds: updated, currentEvents: currentEvents));

      // Dispatch an event to handle the triggered events
      for (final event in currentEvents) {
        // Get code exercise / quiz event details
        if (event.eventType == VideoEventType.CODE) {
          final problemStatement = await codeExerciseDatasource
              .getProblemStatementById(event.payload);

          emit(state.copyWith(problemStatement: problemStatement));
        } else if (event.eventType == VideoEventType.QUIZ) {
          // Handle quiz event if needed
        }
      }
    }
  }

  void _onSelectLecture(SelectLecture event, Emitter<VideoPlayState> emit) {
    // Only initialize if the video URL is different
    if (event.videoUrl != state.currentVideoUrl) {
      emit(state.copyWith(selectedLectureId: event.lectureId));
      add(GetEventsByLectureId(lectureId: event.lectureId));
      add(InitializeVideo(videoUrl: event.videoUrl));
    }
  }

  // Video initialization methods
  Future<void> _onInitializeVideo(
      InitializeVideo event, Emitter<VideoPlayState> emit) async {
    if (state.isDisposed) return;

    emit(state.copyWith(isLoading: true, currentVideoUrl: event.videoUrl));

    // Dispose previous controllers
    _disposeControllers();

    if (event.videoUrl.isEmpty) {
      emit(state.copyWith(isLoading: false, isVideoInitialized: false));
      return;
    }

    if (_isYoutubeUrl(event.videoUrl)) {
      _initializeYoutubeVideo(event.videoUrl, emit);
    } else {
      await _initializeHostedVideo(event.videoUrl, emit);
    }
  }

  void _initializeYoutubeVideo(String url, Emitter<VideoPlayState> emit) {
    // set current video type
    emit(state.copyWith(videoType: VideoType.youtube));

    final videoId = YoutubePlayer.convertUrlToId(url);

    if (videoId == null) {
      emit(state.copyWith(isLoading: false, isVideoInitialized: false));
      return;
    }

    _youtubeController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    )..addListener(() => _registerVideoEventListener);

    emit(state.copyWith(isLoading: false, isVideoInitialized: true));
  }

  Future<void> _initializeHostedVideo(
      String url, Emitter<VideoPlayState> emit) async {
    // set current video type
    emit(state.copyWith(videoType: VideoType.hosted));

    try {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(url));
      await _videoController!.initialize();

      if (state.isDisposed) return;

      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: false,
        looping: false,
      );

      _videoController!.addListener(() => _registerVideoEventListener);

      emit(state.copyWith(isLoading: false, isVideoInitialized: true));
    } catch (e) {
      log('Error initializing hosted video: $e');
      emit(state.copyWith(isLoading: false, isVideoInitialized: false));
    }
  }

  void _registerVideoEventListener() {
    final currentPos = state.videoType == VideoType.youtube
        ? _youtubeController?.value.position.inSeconds
        : _videoController?.value.position.inSeconds;

    if (currentPos != null && currentPos != state.lastLoggedTime) {
      add(UpdatePosition(currentPosition: currentPos));
    }
  }

  void _onVideoPositionChanged(
      UpdatePosition event, Emitter<VideoPlayState> emit) {
    emit(state.copyWith(lastLoggedTime: event.currentPosition));
    add(TriggerEvents());
  }

  // Helper methods
  bool _isYoutubeUrl(String url) {
    return url.contains('youtube.com') ||
        url.contains('youtu.be') ||
        url.contains('youtube-nocookie.com');
  }

  void _onDisposeVideo(DisposeVideo event, Emitter<VideoPlayState> emit) {
    _disposeControllers();
    emit(state.copyWith(isDisposed: true));
  }

  void _onResetVideoState(ResetVideoState event, Emitter<VideoPlayState> emit) {
    emit(const VideoPlayState());
  }

  void _disposeControllers() {
    _chewieController?.dispose();
    _youtubeController?.dispose();
    _videoController?.dispose();
    _chewieController = null;
    _youtubeController = null;
    _videoController = null;
  }

  // Getters for controllers (to be used in view)
  YoutubePlayerController? get youtubeController => _youtubeController;
  VideoPlayerController? get videoController => _videoController;
  ChewieController? get chewieController => _chewieController;

  @override
  Future<void> close() {
    _disposeControllers();
    return super.close();
  }
}
