import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:practice_app/core/error/failures.dart';
import 'package:practice_app/core/usecase/usecase.dart';
import 'package:practice_app/features/notes/domain/entities/note.dart';
import 'package:practice_app/features/notes/domain/repositories/notes_repository.dart';

class AddNote implements UseCase<Note, Params> {
  final NotesRepository notesRepository;

  AddNote(this.notesRepository);

  @override
  Future<Either<Failure, Note>> call(Params params) async {
    return await notesRepository.addNote(params.title, params.description);
  }
}

class Params extends Equatable {
  final String title;
  final String description;
  const Params({required this.title, required this.description});

  @override
  List<Object?> get props => [title, description];
}