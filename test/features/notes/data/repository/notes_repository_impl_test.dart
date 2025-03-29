import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:practice_app/core/error/failures.dart';
import 'package:practice_app/features/notes/data/datasources/notes_local_db_data_source.dart';
import 'package:practice_app/features/notes/data/models/note_model.dart';
import 'package:practice_app/features/notes/data/repositories/notes_repository_impl.dart';

class MockNotesLocalDBDataSource extends Mock implements NotesLocalDBDataSourceImpl {}

void main() {
  late NotesRepositoryImpl repository;
  late MockNotesLocalDBDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockNotesLocalDBDataSource();
    repository = NotesRepositoryImpl(dbDataSource: mockDataSource);
  });

  group('addNote', () {
    test('should return Note on successful insertion', () async {
      final tNoteModel = NoteModel(id: 1, title: 'Test', description: 'Test Desc');
      
      when(() => mockDataSource.addNote(any(), any())).thenAnswer((_) async => tNoteModel);
      
      final result = await repository.addNote('Test', 'Test Desc');
      
      expect(result, Right(tNoteModel));
      verify(() => mockDataSource.addNote('Test', 'Test Desc')).called(1);
    });

    test('should return DBFailure when insertion fails', () async {
      when(() => mockDataSource.addNote(any(), any())).thenThrow(Exception());
      
      final result = await repository.addNote('Test', 'Test Desc');
      
      expect(result, Left(DBFailure()));
      verify(() => mockDataSource.addNote('Test', 'Test Desc')).called(1);
    });
  });

  group('deleteNote', () {
    test('should return true on successful deletion', () async {
      when(() => mockDataSource.deleteNote(any())).thenAnswer((_) async => true);
      
      final result = await repository.deleteNote(1);
      
      expect(result, Right(true));
      verify(() => mockDataSource.deleteNote(1)).called(1);
    });

    test('should return DBFailure when deletion fails', () async {
      when(() => mockDataSource.deleteNote(any())).thenThrow(Exception());
      
      final result = await repository.deleteNote(1);
      
      expect(result, Left(DBFailure()));
      verify(() => mockDataSource.deleteNote(1)).called(1);
    });
  });

  group('getAllNotes', () {
    test('should return list of notes on success', () async {
      final tNotes = [NoteModel(id: 1, title: 'Test', description: 'Test Desc')];
      
      when(() => mockDataSource.getAllNotes()).thenAnswer((_) async => tNotes);
      
      final result = await repository.getAllNotes();
      
      expect(result, Right(tNotes));
      verify(() => mockDataSource.getAllNotes()).called(1);
    });

    test('should return DBFailure when fetching notes fails', () async {
      when(() => mockDataSource.getAllNotes()).thenThrow(Exception());
      
      final result = await repository.getAllNotes();
      
      expect(result, Left(DBFailure()));
      verify(() => mockDataSource.getAllNotes()).called(1);
    });
  });
}
