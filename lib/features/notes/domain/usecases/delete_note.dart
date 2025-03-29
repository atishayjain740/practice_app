import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:practice_app/core/error/failures.dart';
import 'package:practice_app/core/usecase/usecase.dart';
import 'package:practice_app/features/notes/domain/entities/note.dart';
import 'package:practice_app/features/notes/domain/repositories/notes_repository.dart';

class DeleteNote implements UseCase<bool, Params> {
  final NotesRepository notesRepository;

  DeleteNote(this.notesRepository);

  @override
  Future<Either<Failure, bool>> call(Params params) async {
    return await notesRepository.deleteNote(params.id);
  }
}

class Params extends Equatable {
  final int id;
  const Params({required this.id});

  @override
  List<Object?> get props => [id];
}