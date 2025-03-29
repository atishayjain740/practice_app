import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:practice_app/features/notes/data/datasources/notes_local_db_data_source.dart';
import 'package:sqflite/sqflite.dart';
import 'package:practice_app/core/error/exceptions.dart';
import 'package:practice_app/features/notes/data/models/note_model.dart';

class MockDatabase extends Mock implements Database {}

void main() {
  late NotesLocalDBDataSourceImpl dataSource;
  late MockDatabase mockDatabase;

  setUp(() {
    mockDatabase = MockDatabase();
    dataSource = NotesLocalDBDataSourceImpl(database: mockDatabase);
  });

  group('getAllNotes', () {
    test('should return list of NoteModel when query is successful', () async {
      when(() => mockDatabase.query(notesTable)).thenAnswer((_) async => [
            {'id': 1, 'title': 'Test Title', 'description': 'Test Description'}
          ]);
      
      final result = await dataSource.getAllNotes();
      
      expect(result, isA<List<NoteModel>>());
      expect(result.length, 1);
      expect(result.first.id, 1);
      verify(() => mockDatabase.query(notesTable)).called(1);
    });

    test('should throw DBException when query fails', () async {
      when(() => mockDatabase.query(notesTable)).thenThrow(Exception());
      
      expect(() => dataSource.getAllNotes(), throwsA(isA<DBException>()));
      verify(() => mockDatabase.query(notesTable)).called(1);
    });
  });

  group('addNote', () {
    test('should return NoteModel when insertion is successful', () async {
      when(() => mockDatabase.insert(notesTable, any(), conflictAlgorithm: any(named: 'conflictAlgorithm')))
          .thenAnswer((_) async => 1);
      
      final result = await dataSource.addNote('New Note', 'This is a note');
      
      expect(result, isA<NoteModel>());
      expect(result.id, 1);
      expect(result.title, 'New Note');
      verify(() => mockDatabase.insert(notesTable, any(), conflictAlgorithm: ConflictAlgorithm.replace)).called(1);
    });

    test('should throw DBException when insertion fails', () async {
      when(() => mockDatabase.insert(notesTable, any(), conflictAlgorithm: any(named: 'conflictAlgorithm')))
          .thenThrow(Exception());
      
      expect(() => dataSource.addNote('New Note', 'This is a note'), throwsA(isA<DBException>()));
      verify(() => mockDatabase.insert(notesTable, any(), conflictAlgorithm: ConflictAlgorithm.replace)).called(1);
    });
  });

  group('deleteNote', () {
    test('should return true when deletion is successful', () async {
      when(() => mockDatabase.delete(notesTable, where: any(named: 'where'), whereArgs: any(named: 'whereArgs')))
          .thenAnswer((_) async => 1);
      
      final result = await dataSource.deleteNote(1);
      
      expect(result, true);
      verify(() => mockDatabase.delete(notesTable, where: 'id = ?', whereArgs: [1])).called(1);
    });

    test('should throw DBException when deletion fails', () async {
      when(() => mockDatabase.delete(notesTable, where: any(named: 'where'), whereArgs: any(named: 'whereArgs')))
          .thenThrow(Exception());
      
      expect(() => dataSource.deleteNote(1), throwsA(isA<DBException>()));
      verify(() => mockDatabase.delete(notesTable, where: 'id = ?', whereArgs: [1])).called(1);
    });
  });
}