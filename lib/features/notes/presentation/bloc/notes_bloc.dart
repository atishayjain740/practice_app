import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_app/core/usecase/usecase.dart';
import 'package:practice_app/features/notes/domain/usecases/add_note.dart';
import 'package:practice_app/features/notes/domain/usecases/delete_note.dart'
    as dn;
import 'package:practice_app/features/notes/domain/usecases/get_all_notes.dart';
import 'package:practice_app/features/notes/presentation/bloc/notes_event.dart';
import 'package:practice_app/features/notes/presentation/bloc/notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final GetAllNotes getAllNotes;
  final AddNote addNote;
  final dn.DeleteNote deleteNote;

  NotesBloc({
    required this.getAllNotes,
    required this.addNote,
    required this.deleteNote,
  }) : super(NotesEmpty()) {
    on<GetAllNotesEvent>((event, emit) async {
      emit(NotesLoading());
      final result = await getAllNotes(NoParams());
      result.fold(
        (failure) => emit(
          NotesError(message: "There was some problem loading the notes."),
        ),
        (notes) {
          if (notes.isEmpty) {
            emit(NotesEmpty());
          } else {
            emit(NotesLoaded(notes: notes));
          }
        },
      );
    });

    on<AddNoteEvent>((event, emit) async {
      emit(NotesLoading());
      final result = await addNote(
        Params(title: event.title, description: event.description),
      );
      result.fold(
        (failure) => emit(
          NotesError(
            message:
                "There was some problem adding the note. Please try again.",
          ),
        ),
        (note) {
          add(GetAllNotesEvent());
        },
      );
    });

    on<DeleteNoteEvent>((event, emit) async {
      emit(NotesLoading());
      final result = await deleteNote(dn.Params(id: event.id));
      result.fold(
        (failure) => emit(
          NotesError(
            message:
                "There was some problem deleting the note. Please try again.",
          ),
        ),
        (note) {
          add(GetAllNotesEvent());
        },
      );
    });
  }
}
