import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:practice_app/core/error/failures.dart';
import 'package:practice_app/core/usecase/usecase.dart';
import 'package:practice_app/features/notes/domain/entities/note.dart';
import 'package:practice_app/features/notes/domain/usecases/add_note.dart';
import 'package:practice_app/features/notes/domain/usecases/delete_note.dart' as dn;
import 'package:practice_app/features/notes/domain/usecases/get_all_notes.dart';
import 'package:practice_app/features/notes/presentation/bloc/notes_bloc.dart';
import 'package:practice_app/features/notes/presentation/bloc/notes_event.dart';
import 'package:practice_app/features/notes/presentation/bloc/notes_state.dart';

class MockGetAllNotes extends Mock implements GetAllNotes {}
class MockAddNote extends Mock implements AddNote {}
class MockDeleteNote extends Mock implements dn.DeleteNote {}

void main() {
  late NotesBloc notesBloc;
  late MockGetAllNotes mockGetAllNotes;
  late MockAddNote mockAddNote;
  late MockDeleteNote mockDeleteNote;

  setUp(() {
    mockGetAllNotes = MockGetAllNotes();
    mockAddNote = MockAddNote();
    mockDeleteNote = MockDeleteNote();
    notesBloc = NotesBloc(
      getAllNotes: mockGetAllNotes,
      addNote: mockAddNote,
      deleteNote: mockDeleteNote,
    );
  });

  const testNote = Note(id: 1, title: 'Test Note', description: 'Test Description');
  final testNotesList = [testNote];

  group('GetAllNotesEvent', () {
    blocTest<NotesBloc, NotesState>(
      'emits [NotesLoading, NotesLoaded] when notes are retrieved successfully',
      build: () {
        when(() => mockGetAllNotes(NoParams()))
            .thenAnswer((_) async => Right(testNotesList));
        return notesBloc;
      },
      act: (bloc) => bloc.add(GetAllNotesEvent()),
      expect: () => [NotesLoading(), NotesLoaded(notes: testNotesList)],
    );

    blocTest<NotesBloc, NotesState>(
      'emits [NotesLoading, NotesError] when getting notes fails',
      build: () {
        when(() => mockGetAllNotes(NoParams()))
            .thenAnswer((_) async => Left(DBFailure()));
        return notesBloc;
      },
      act: (bloc) => bloc.add(GetAllNotesEvent()),
      expect: () => [NotesLoading(), NotesError(message: "There was some problem loading the notes.")],
    );
  });

  group('AddNoteEvent', () {
    blocTest<NotesBloc, NotesState>(
      'calls AddNote usecase and refreshes notes when successful',
      build: () {
        when(() => mockAddNote(Params(title: testNote.title, description: testNote.description)))
            .thenAnswer((_) async => Right(testNote));
        when(() => mockGetAllNotes(NoParams()))
            .thenAnswer((_) async => Right(testNotesList));
        return notesBloc;
      },
      act: (bloc) => bloc.add(AddNoteEvent(title: testNote.title, description: testNote.description)),
      expect: () => [NotesLoading(), NotesLoaded(notes: testNotesList)],
    );

    blocTest<NotesBloc, NotesState>(
      'emits [NotesLoading, NotesError] when adding a note fails',
      build: () {
        when(() => mockAddNote(Params(title: testNote.title, description: testNote.description)))
            .thenAnswer((_) async => Left(DBFailure()));
        return notesBloc;
      },
      act: (bloc) => bloc.add(AddNoteEvent(title: testNote.title, description: testNote.description)),
      expect: () => [NotesLoading(), NotesError(message: "There was some problem adding the note. Please try again.")],
    );
  });

  group('DeleteNoteEvent', () {
    blocTest<NotesBloc, NotesState>(
      'calls DeleteNote usecase and refreshes notes when successful',
      build: () {
        when(() => mockDeleteNote(dn.Params(id: testNote.id)))
            .thenAnswer((_) async => Right(true));
        when(() => mockGetAllNotes(NoParams()))
            .thenAnswer((_) async => Right([]));
        return notesBloc;
      },
      act: (bloc) => bloc.add(DeleteNoteEvent(id: testNote.id)),
      expect: () => [NotesLoading(), NotesEmpty()],
    );

    blocTest<NotesBloc, NotesState>(
      'emits [NotesLoading, NotesError] when deleting a note fails',
      build: () {
        when(() => mockDeleteNote(dn.Params(id: testNote.id)))
            .thenAnswer((_) async => Left(DBFailure()));
        return notesBloc;
      },
      act: (bloc) => bloc.add(DeleteNoteEvent(id: testNote.id)),
      expect: () => [NotesLoading(), NotesError(message: "There was some problem deleting the note. Please try again.")],
    );
  });
}
