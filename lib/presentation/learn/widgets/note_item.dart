import 'package:e_learning_mobile/common/extensions/context_extension.dart';
import 'package:e_learning_mobile/common/theme/palette.dart';
import 'package:e_learning_mobile/common/utils/format_util.dart';
import 'package:e_learning_mobile/data/dtos/notes/note_response_dto.dart';
import 'package:e_learning_mobile/presentation/learn/bloc/notes/notes_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NoteItem extends StatelessWidget {
  final NoteResponseDto note;

  const NoteItem({
    super.key,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(note.lectureTitle,
                  textAlign: TextAlign.start,
                  style: context.textStyles.subHeading2
                      .copyWith(fontWeight: FontWeight.bold)),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Palette.light().primaryColor,
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: note.videoTimestamp != null
                  ? Text(
                      FormatUtil.convertTimestampToDuration(
                          note.videoTimestamp!),
                      style: context.textStyles.body2
                          .copyWith(color: Colors.white))
                  : null,
            ),
          ],
        ),
        SizedBox(height: 8.0),
        Row(
          children: [
            Expanded(
              child: Text(note.content, style: context.textStyles.body1),
            ),
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'edit') {
                  final controller = TextEditingController(text: note.content);
                  final result = await showDialog<String>(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        title: Text('Edit note'),
                        content: TextField(
                          controller: controller,
                          maxLines: 4,
                          decoration:
                              InputDecoration(hintText: 'Enter note content'),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: Text('Cancel')),
                          ElevatedButton(
                              onPressed: () =>
                                  Navigator.pop(ctx, controller.text),
                              child: Text('Save')),
                        ],
                      );
                    },
                  );
                  if (context.mounted &&
                      result != null &&
                      result.trim().isNotEmpty) {
                    context.read<NotesBloc>().add(UpdateNoteEvent(
                          noteId: note.noteId,
                          content: result.trim(),
                          timestamp: note.videoTimestamp,
                        ));
                  }
                } else if (value == 'delete') {
                  context.read<NotesBloc>().add(DeleteNoteEvent(note.noteId));
                }
              },
              itemBuilder: (ctx) => const [
                PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ],
        )
      ],
    );
  }
}
