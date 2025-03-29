import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:practice_app/features/notes/domain/entities/note.dart';
import 'package:practice_app/features/notes/domain/repositories/notes_repository.dart';
import 'package:practice_app/features/notes/domain/usecases/delete_note.dart';

class MockNotesRepository extends Mock implements NotesRepository{}

void main() {
  final int id = 1;
  final Note note = Note(id: id, title: 'test title', description: 'test description');
  late MockNotesRepository mockNotesRepository;
  late DeleteNote useCase;

  setUp(() {
    mockNotesRepository = MockNotesRepository();
    useCase = DeleteNote(mockNotesRepository);
  });

  test("should delete note from the repository", () async {
    // arrange
    when(
      () => mockNotesRepository.deleteNote(id)
    ).thenAnswer((_) async => Right(true));
    // act
    final result = await useCase(Params(id: id));
    // assert
    expect(result, Right(true));
    verify(() => mockNotesRepository.deleteNote(id));
    verifyNoMoreInteractions(mockNotesRepository);
  });
}
