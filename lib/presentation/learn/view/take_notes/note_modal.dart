import 'dart:developer';

import 'package:e_learning_mobile/data/dtos/lectures/lecture_response_dto.dart';
import 'package:e_learning_mobile/presentation/learn/bloc/notes/notes_bloc.dart';
import 'package:e_learning_mobile/presentation/learn/widgets/comment_input_with_mention.dart';
import 'package:e_learning_mobile/presentation/learn/widgets/note_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class NoteModal extends StatefulWidget {
  final LectureResponseDto? selectedLecture;
  final VideoPlayerController? videoController;
  final YoutubePlayerController? youtubeController;
  const NoteModal(
      {super.key,
      this.selectedLecture,
      required this.videoController,
      required this.youtubeController});

  @override
  State<NoteModal> createState() => _NoteModalState();
}

class _NoteModalState extends State<NoteModal> {
  @override
  void initState() {
    if (widget.selectedLecture != null) {
      context
          .read<NotesBloc>()
          .add(LoadNotesByLectureId(widget.selectedLecture!.lectureId));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext buildContext) {
    return Container(
      padding: EdgeInsets.all(16.0),
      height: MediaQuery.of(buildContext).size.height * 0.8,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              // modal title
              Row(
                children: [
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Center(
                          child: Text('Notes',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () => Navigator.pop(buildContext),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  // select which lecture this note belongs to
                  Expanded(
                    child: DropdownMenu(
                        width: double.infinity,
                        // enabled: false,
                        initialSelection: 1,
                        menuStyle: MenuStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white)),
                        inputDecorationTheme: InputDecorationTheme(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40))),
                        dropdownMenuEntries: [
                          DropdownMenuEntry(value: 1, label: 'All lectures'),
                          DropdownMenuEntry(value: 2, label: 'This lecture'),
                        ],
                        trailingIcon: Icon(Icons.arrow_drop_down)),
                  ),
                  const SizedBox(width: 8),

                  // dropdown to select filter
                  Expanded(
                    child: DropdownMenu(
                        width: double.infinity,
                        enabled: true,
                        menuStyle: MenuStyle(
                            backgroundColor: MaterialStateProperty.all(Colors
                                .white)), // Customize menu style if needed
                        initialSelection: 1,
                        inputDecorationTheme: InputDecorationTheme(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40))),
                        dropdownMenuEntries: [
                          DropdownMenuEntry(value: 1, label: 'Most recent'),
                          DropdownMenuEntry(value: 2, label: 'Oldest first'),
                        ],
                        trailingIcon: Icon(Icons.arrow_drop_down)),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Notes list
              Expanded(
                child: BlocBuilder<NotesBloc, NotesState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (state.errorMessage != null) {
                      return Center(
                          child: Text('Error: ${state.errorMessage}'));
                    }
                    if (state.notes.isEmpty) {
                      return Center(child: Text('Let write your first note'));
                    }
                    return ListView.separated(
                      itemCount: state.notes.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final note = state.notes[index];
                        return NoteItem(note: note);
                      },
                    );
                  },
                ),
              ),

              // write note area (like youtube comment box)
              CommentInputWithMention(
                videoController: widget.videoController,
                youtubeController: widget.youtubeController,
                onSubmit: (content, timestamp) {
                  log('Submitting note: content="$content", timestamp=$timestamp');
                  log('Selected lecture ID: ${widget.selectedLecture?.lectureId}');
                  buildContext.read<NotesBloc>().add(CreateNoteEvent(
                        lectureId: widget.selectedLecture!.lectureId,
                        content: content.trim(),
                        timestamp: timestamp,
                      ));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
