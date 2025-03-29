import 'package:practice_app/features/notes/domain/entities/note.dart';

class NoteModel extends Note {
  NoteModel({required super.id, required super.title, required super.description});

  NoteModel.fromJson(Map<String, dynamic> json)
      : super(
          id: json['id'],
          title: json['title'],
          description: json['description']
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    return data;
  }
  
}