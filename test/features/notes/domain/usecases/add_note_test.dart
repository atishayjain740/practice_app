import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:practice_app/features/notes/domain/entities/note.dart';
import 'package:practice_app/features/notes/domain/repositories/notes_repository.dart';
import 'package:practice_app/features/notes/domain/usecases/add_note.dart';

class MockNotesRepository extends Mock implements NotesRepository{}

void main() {
  final String title = 'test title';
  final String description = 'test description';
  final Note note = Note(id: 1, title: title, description: description);
  late MockNotesRepository mockNotesRepository;
  late AddNote useCase;

  setUp(() {
    mockNotesRepository = MockNotesRepository();
    useCase = AddNote(mockNotesRepository);
  });

  test("should add note to the repository", () async {
    // arrange
    when(
      () => mockNotesRepository.addNote(title, description)
    ).thenAnswer((_) async => Right(note));
    // act
    final result = await useCase(Params(title: title, description: description));
    // assert
    expect(result, Right(note));
    verify(() => mockNotesRepository.addNote(title, description));
    verifyNoMoreInteractions(mockNotesRepository);
  });
}
