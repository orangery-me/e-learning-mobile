part of 'notes_bloc.dart';

sealed class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object> get props => [];
}

class LoadNotesByLectureId extends NotesEvent {
  final String lectureId;
  const LoadNotesByLectureId(this.lectureId);
}

class CreateNoteEvent extends NotesEvent {
  final String lectureId;
  final String content;
  final int? timestamp;
  const CreateNoteEvent(
      {required this.lectureId, required this.content, this.timestamp});
}

class GetNoteByIdEvent extends NotesEvent {
  final String noteId;
  const GetNoteByIdEvent(this.noteId);
}

class UpdateNoteEvent extends NotesEvent {
  final String noteId;
  final String content;
  final int? timestamp;
  const UpdateNoteEvent(
      {required this.noteId, required this.content, this.timestamp});
}

class DeleteNoteEvent extends NotesEvent {
  final String noteId;
  const DeleteNoteEvent(this.noteId);
}
