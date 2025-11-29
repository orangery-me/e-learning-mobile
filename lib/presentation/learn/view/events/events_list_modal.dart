import 'package:e_learning_mobile/data/dtos/enrollment/enrollment_dto.dart';
import 'package:e_learning_mobile/data/dtos/video_event/video_event.dart';
import 'package:e_learning_mobile/presentation/learn/view/code_exercises/code_exercise_modal.dart';
import 'package:e_learning_mobile/presentation/learn/view/quizz/quizz_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_learning_mobile/presentation/learn/bloc/video_play/video_play_bloc.dart';

class EventsListModal extends StatelessWidget {
  final EnrollmentDto enrollment;
  const EventsListModal({super.key, required this.enrollment});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoPlayBloc, VideoPlayState>(
      builder: (context, state) {
        // Get all triggered events
        final triggeredEvents = state.events
            .where((event) => state.triggeredIds.contains(event.id))
            .toList();

        return Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  const Icon(Icons.event_note, size: 24, color: Colors.blue),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Exercise Events',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Content
            if (triggeredEvents.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.event_busy,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No events available yet',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          'Complete exercises during video playback to see them here',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: triggeredEvents.length,
                  itemBuilder: (context, index) {
                    final event = triggeredEvents[index];
                    return _EventCard(
                      enrollmentId: enrollment.id,
                      event: event,
                      index: index,
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}

class _EventCard extends StatelessWidget {
  final String enrollmentId;
  final VideoEvent event;
  final int index;

  const _EventCard({
    required this.enrollmentId,
    required this.event,
    required this.index,
  });

  void _onEventTap(VideoEvent event, BuildContext context) {
    if (event.eventType == VideoEventType.CODE) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (_) => CodeExercisePage(problemId: event.payload),
      );
    } else if (event.eventType == VideoEventType.QUIZ) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (_) =>
            QuizzPage(enrollmentId: enrollmentId, quizzId: event.payload),
      );
    }
  }

  String _getEventTitle(VideoEventType type) {
    return switch (type) {
      VideoEventType.CODE => 'Code Exercise',
      VideoEventType.QUIZ => 'Quiz',
    };
  }

  IconData _getEventIcon(VideoEventType type) {
    return switch (type) {
      VideoEventType.CODE => Icons.code,
      VideoEventType.QUIZ => Icons.quiz,
    };
  }

  Color _getEventColor(VideoEventType type) {
    return switch (type) {
      VideoEventType.CODE => Colors.blue,
      VideoEventType.QUIZ => Colors.purple,
    };
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes}m ${remainingSeconds}s';
  }

  @override
  Widget build(BuildContext context) {
    final eventColor = _getEventColor(event.eventType);
    final eventIcon = _getEventIcon(event.eventType);
    final eventTitle = _getEventTitle(event.eventType);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _onEventTap(event, context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: eventColor.withOpacity(0.2),
              width: 2,
            ),
          ),
          child: Row(
            children: [
              // Event Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: eventColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  eventIcon,
                  color: eventColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),

              // Event Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$eventTitle #${index + 1}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Triggered at ${_formatTime(event.triggerTime)}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Arrow Icon
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
