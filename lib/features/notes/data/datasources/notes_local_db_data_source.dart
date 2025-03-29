import 'package:path/path.dart';
import 'package:practice_app/features/notes/data/models/note_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:practice_app/core/error/exceptions.dart';

abstract class NotesLocalDBDataSource {
  Future<NoteModel> addNote(String title, String description);
  Future<bool> deleteNote(int id);
  Future<List<NoteModel>> getAllNotes();
}

const String notesTable = 'notes';
const String notesTableCreateQuery = '''
  CREATE TABLE $notesTable (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT,
    description TEXT
  )
''';

Future<Database> initNotesDb() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'notes.db');
  return await openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      await db.execute(notesTableCreateQuery);
    },
  );
}

class NotesLocalDBDataSourceImpl implements NotesLocalDBDataSource {
  final Database database;

  NotesLocalDBDataSourceImpl({required this.database});

  @override
  Future<List<NoteModel>> getAllNotes() async {
    try {
      final result = await database.query(notesTable);
      List<NoteModel> allNotes = [];
      for (final note in result) {
        allNotes.add(NoteModel.fromJson(note));
      }
      return allNotes;
    } catch (e) {
      throw DBException();
    }
  }

  @override
  Future<NoteModel> addNote(String title, String description) async {
    try {
      int id = await database.insert(notesTable, {
        "title": title,
        "description": description,
      }, conflictAlgorithm: ConflictAlgorithm.replace);

      return NoteModel(id: id, title: title, description: description);
    } catch (e) {
      throw DBException();
    }
  }

  @override
  Future<bool> deleteNote(int id) async {
    try {
      await database.delete('notes', where: 'id = ?', whereArgs: [id]);
      return true;
    } catch (e) {
      throw DBException();
    }
  }
}
