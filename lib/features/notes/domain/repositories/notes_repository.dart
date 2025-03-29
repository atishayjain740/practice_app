import 'package:dartz/dartz.dart';
import 'package:practice_app/core/error/failures.dart';
import 'package:practice_app/features/notes/domain/entities/note.dart';

abstract class NotesRepository {
  Future<Either<Failure, List<Note>>> getAllNotes();
  Future<Either<Failure, Note>> addNote(String title, String description);
  Future<Either<Failure, bool>> deleteNote(int id);
}