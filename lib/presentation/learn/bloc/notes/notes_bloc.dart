import 'package:bloc/bloc.dart';
import 'package:e_learning_mobile/data/datasources/note/note_datasource.dart';
import 'package:e_learning_mobile/data/dtos/notes/note_request_dto.dart';
import 'package:e_learning_mobile/data/dtos/notes/note_response_dto.dart';
import 'package:equatable/equatable.dart';
import 'dart:developer';
import 'package:injectable/injectable.dart';

part 'notes_event.dart';
part 'notes_state.dart';

@injectable
class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NoteDatasource datasource;

  NotesBloc({required this.datasource}) : super(const NotesState()) {
    on<LoadNotesByLectureId>((event, emit) => _loadNotes(event, emit));
    on<CreateNoteEvent>((event, emit) => _createNote(event, emit));
    on<GetNoteByIdEvent>((event, emit) => _getNoteById(event, emit));
    on<UpdateNoteEvent>((event, emit) => _updateNote(event, emit));
    on<DeleteNoteEvent>((event, emit) => _deleteNote(event, emit));
  }

  Future<void> _loadNotes(
      LoadNotesByLectureId event, Emitter<NotesState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final notes = await datasource.getAllNotes(event.lectureId);
      emit(state.copyWith(notes: notes, isLoading: false));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _createNote(
      CreateNoteEvent event, Emitter<NotesState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final created = await datasource.createNote(NoteCreateRequestDto(
        lectureId: event.lectureId,
        content: event.content,
        videoTimestamp: event.timestamp,
      ));
      final updated = List<NoteResponseDto>.from(state.notes)
        ..insert(0, created);
      emit(state.copyWith(notes: updated, isLoading: false));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _getNoteById(
      GetNoteByIdEvent event, Emitter<NotesState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final note = await datasource.getNoteById(event.noteId);
      emit(state.copyWith(selectedNote: note, isLoading: false));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _updateNote(
      UpdateNoteEvent event, Emitter<NotesState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final updated = await datasource.updateNote(
        event.noteId,
        NoteUpdateRequestDto(
            content: event.content, timestamp: event.timestamp),
      );
      final newList = state.notes
          .map((n) => n.noteId == updated.noteId ? updated : n)
          .toList();
      emit(state.copyWith(
          notes: newList, selectedNote: updated, isLoading: false));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _deleteNote(
      DeleteNoteEvent event, Emitter<NotesState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await datasource.deleteNote(event.noteId);
      final newList =
          state.notes.where((n) => n.noteId != event.noteId).toList();
      emit(state.copyWith(notes: newList, isLoading: false));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
