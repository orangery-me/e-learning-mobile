import 'dart:developer';

import 'package:e_learning_mobile/data/datasources/code_exercise/code_exercise_datasource.dart';
import 'package:e_learning_mobile/data/datasources/quizz/quizz_datasource.dart';
import 'package:e_learning_mobile/data/dtos/video_event/video_event.dart';
import 'package:e_learning_mobile/di/di.dart';
import 'package:e_learning_mobile/presentation/learn/view/code_exercises/code_exercise_modal.dart';
import 'package:e_learning_mobile/presentation/learn/view/quizz/quizz_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_learning_mobile/presentation/learn/bloc/video_play/video_play_bloc.dart';

class EventsListModal extends StatelessWidget {
  const EventsListModal({super.key});

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
  final VideoEvent event;
  final int index;

  const _EventCard({
    required this.event,
    required this.index,
  });

  Future<void> _onEventTap(VideoEvent event, BuildContext context) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      if (event.eventType == VideoEventType.CODE) {
        // Fetch the problem statement
        final codeExerciseDatasource = getIt<CodeExerciseDatasource>();
        final problemStatement =
            await codeExerciseDatasource.getProblemStatementById(event.payload);

        // Close loading dialog
        if (context.mounted) {
          Navigator.pop(context);
        }

        // Open code exercise modal
        if (context.mounted) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (_) => CodeExercisePage(
              problemStatement: problemStatement,
            ),
          );
        }
      } else if (event.eventType == VideoEventType.QUIZ) {
        final quizDatasource = getIt<QuizzDatasource>();
        final quiz = await quizDatasource.getQuizzById(event.payload);

        // Close loading dialog
        if (context.mounted) {
          Navigator.pop(context);
        }

        // Open quiz modal
        if (context.mounted) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (_) => QuizzPage(quizzId: quiz.id),
          );
        }
      }
    } catch (e) {
      // Close loading dialog
      if (context.mounted) {
        Navigator.pop(context);
      }
      log('Error fetching problem statement: $e');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading exercise: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
