import 'package:dartz/dartz.dart';
import 'package:practice_app/core/error/failures.dart';
import 'package:practice_app/features/notes/data/datasources/notes_local_db_data_source.dart';
import 'package:practice_app/features/notes/data/models/note_model.dart';
import 'package:practice_app/features/notes/domain/entities/note.dart';
import 'package:practice_app/features/notes/domain/repositories/notes_repository.dart';

class NotesRepositoryImpl implements NotesRepository {
  final NotesLocalDBDataSource dbDataSource;

  const NotesRepositoryImpl({required this.dbDataSource});

  @override
  Future<Either<Failure, Note>> addNote(
    String title,
    String description,
  ) async {
    try {
      NoteModel note = await dbDataSource.addNote(title, description);
      return Right(note);
    } catch (e) {
      return Left(DBFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteNote(int id) async {
    try {
      bool result = await dbDataSource.deleteNote(id);
      if (result) {
        return Right(result);
      } else {
        return Left(DBFailure());
      }
    } catch (e) {
      return Left(DBFailure());
    }
  }

  @override
  Future<Either<Failure, List<Note>>> getAllNotes() async {
    try {
      return Right(await dbDataSource.getAllNotes());
    } catch (e) {
      return Left(DBFailure());
    }
  }
}
