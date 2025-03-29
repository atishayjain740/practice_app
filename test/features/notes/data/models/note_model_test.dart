import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:practice_app/features/notes/data/models/note_model.dart';
import 'package:practice_app/features/notes/domain/entities/note.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  NoteModel noteModel = NoteModel(
    id: 1,
    title: 'test title',
    description: 'test description',
  );

  test("should be a note entity", () {
    expect(noteModel, isA<Note>());
  });

  group('from json', () {
    test("should return a valid model when the json is correct", () async {
      final Map<String, dynamic> jsonMap = json.decode(fixture('note.json'));
      final result = NoteModel.fromJson(jsonMap);

      expect(result, isInstanceOf<NoteModel>());
    });

    test("should return exception when the json is incorrect", () async {
      final Map<String, dynamic> jsonMap = json.decode(
        fixture('note_invalid.json'),
      );
      expect(() => NoteModel.fromJson(jsonMap), throwsA(isA<TypeError>()));
    });
  });

  group('to json', () {
    test("should return a json map containing the proper data", () async {
      final result = noteModel.toJson();
      final Map<String, dynamic> expectedMap = json.decode(
        fixture('note.json'),
      );
      expect(result, expectedMap);
    });
  });
}
