import 'package:e_learning_mobile/data/datasources/note/remote/note_remote_datasource.dart';
import 'package:e_learning_mobile/data/dtos/notes/note_request_dto.dart';
import 'package:e_learning_mobile/data/dtos/notes/note_response_dto.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class NoteDatasource {
  final NoteRemoteDatasource _remote;

  NoteDatasource({required NoteRemoteDatasource remote}) : _remote = remote;

  Future<List<NoteResponseDto>> getAllNotes(String lectureId) =>
      _remote.getAllNotes(lectureId);

  Future<NoteResponseDto> createNote(NoteCreateRequestDto dto) =>
      _remote.createNote(dto);

  Future<NoteResponseDto> getNoteById(String noteId) =>
      _remote.getNoteById(noteId);

  Future<NoteResponseDto> updateNote(String noteId, NoteUpdateRequestDto dto) =>
      _remote.updateNote(noteId, dto);

  Future<void> deleteNote(String noteId) => _remote.deleteNote(noteId);
}
