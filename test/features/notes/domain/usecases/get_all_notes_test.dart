import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:practice_app/core/usecase/usecase.dart';
import 'package:practice_app/features/notes/domain/entities/note.dart';
import 'package:practice_app/features/notes/domain/repositories/notes_repository.dart';
import 'package:practice_app/features/notes/domain/usecases/get_all_notes.dart';

class MockNotesRepository extends Mock implements NotesRepository{}

void main() {
  final Note note = Note(id: 1, title: 'test title', description: 'test description');
  final List<Note> notes = [note];
  late MockNotesRepository mockNotesRepository;
  late GetAllNotes useCase;

  setUp(() {
    mockNotesRepository = MockNotesRepository();
    useCase = GetAllNotes(mockNotesRepository);
  });

  test("should get all notes from the repository", () async {
    // arrange
    when(
      () => mockNotesRepository.getAllNotes()
    ).thenAnswer((_) async => Right(notes));
    // act
    final result = await useCase(NoParams());
    // assert
    expect(result, Right(notes));
    verify(() => mockNotesRepository.getAllNotes());
    verifyNoMoreInteractions(mockNotesRepository);
  });
}
