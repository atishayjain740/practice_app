import 'package:dartz/dartz.dart';
import 'package:practice_app/core/error/failures.dart';
import 'package:practice_app/core/usecase/usecase.dart';
import 'package:practice_app/features/notes/domain/entities/note.dart';
import 'package:practice_app/features/notes/domain/repositories/notes_repository.dart';

class GetAllNotes implements UseCase<List<Note>, NoParams> {
  final NotesRepository notesRepository;

  GetAllNotes(this.notesRepository);

  @override
  Future<Either<Failure, List<Note>>> call(NoParams params) async {
    return await notesRepository.getAllNotes();
  }
}