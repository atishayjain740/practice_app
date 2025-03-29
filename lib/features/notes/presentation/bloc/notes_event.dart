import 'package:equatable/equatable.dart';

class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object> get props => [];
}

class GetAllNotesEvent extends NotesEvent {}

class AddNoteEvent extends NotesEvent {
  final String title;
  final String description;

  const AddNoteEvent({required this.title, required this.description});
}

class DeleteNoteEvent extends NotesEvent {
  final int id;

  const DeleteNoteEvent({required this.id});
}