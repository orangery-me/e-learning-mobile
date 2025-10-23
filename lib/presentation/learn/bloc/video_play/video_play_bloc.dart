import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:e_learning_mobile/data/datasources/code_exercise/code_exercise_datasource.dart';
import 'package:e_learning_mobile/data/datasources/video_events/video_events_datasource.dart';
import 'package:e_learning_mobile/data/dtos/code/problem_statement/code_problem_statement.dart';
import 'package:e_learning_mobile/data/dtos/video_event/video_event.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'video_play_event.dart';
part 'video_play_state.dart';

@injectable
class VideoPlayBloc extends Bloc<VideoPlayEvent, VideoPlayState> {
  final VideoEventsDatasource videoEventsDatasource;
  final CodeExerciseDatasource codeExerciseDatasource;

  VideoPlayBloc(this.videoEventsDatasource, this.codeExerciseDatasource)
      : super(const VideoPlayState()) {
    on<GetEventsByLectureId>(_onGetEventsByLectureId);
    on<UpdatePosition>(_onUpdatePosition);
    on<TriggerEvents>(_triggerEvent);
    on<AskToDoExercise>((event, emit) =>
        emit(state.copyWith(acceptToDoExercise: event.acceptToDoExercise)));
    on<SetVideoType>(_onSetVideoType);
  }

  void _onGetEventsByLectureId(
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

  void _onUpdatePosition(UpdatePosition event, Emitter<VideoPlayState> emit) {
    final triggered = <VideoEvent>{};

    for (final e in state.events) {
      // Check if this event should be triggered at the current position and not already triggered
      if (event.positionSeconds == e.triggerTime &&
          !state.triggeredIds.contains(e.id)) {
        // Mark this event as triggered
        triggered.add(e);
        log('Triggering event ${e.eventType} at ${event.positionSeconds}s');
      }
    }

    if (triggered.isNotEmpty) {
      final updated = {...state.triggeredIds, ...triggered.map((e) => e.id)};
      final currentEvents = triggered.toList();

      emit(state.copyWith(triggeredIds: updated, currentEvents: currentEvents));

      // Dispatch an event to handle the triggered events
      // add(TriggerEvents(eventsToTrigger: currentEvents));
    }
  }

  void _triggerEvent(TriggerEvents event, Emitter<VideoPlayState> emit) async {
    for (final event in event.eventsToTrigger) {
      // Get code exercise / quiz event details
      if (event.eventType != VideoEventType.CODE) continue;
      final problemStatement =
          await codeExerciseDatasource.getProblemStatementById(event.payload);
      emit(state.copyWith(problemStatement: problemStatement));
    }
  }
}
