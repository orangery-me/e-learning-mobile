part of 'notes_bloc.dart';

final class NotesState extends Equatable {
  final List<NoteResponseDto> notes;
  final NoteResponseDto? selectedNote;
  final bool isLoading;
  final String? errorMessage;

  const NotesState({
    this.notes = const [],
    this.selectedNote,
    this.isLoading = false,
    this.errorMessage,
  });

  NotesState copyWith({
    List<NoteResponseDto>? notes,
    NoteResponseDto? selectedNote,
    bool? isLoading,
    String? errorMessage,
  }) {
    return NotesState(
      notes: notes ?? this.notes,
      selectedNote: selectedNote ?? this.selectedNote,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [notes, selectedNote, isLoading, errorMessage];
}
