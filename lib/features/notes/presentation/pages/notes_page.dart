import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:practice_app/core/router/router.dart';
import 'package:practice_app/core/widgets/display_text.dart';
import 'package:practice_app/features/notes/domain/entities/note.dart';
import 'package:practice_app/features/notes/presentation/bloc/notes_bloc.dart';
import 'package:practice_app/features/notes/presentation/bloc/notes_event.dart';
import 'package:practice_app/features/notes/presentation/bloc/notes_state.dart';
import 'package:practice_app/features/notes/presentation/widgets/custom_note_card.dart';


class NotesPage extends StatelessWidget {
  final String _strCounter = 'Notes';
  final String _strInitialText = "Click on the + icon to add notes";

  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).pop(),
        ),
        title: Text(_strCounter),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoRouter.of(context).push(addnoteRoute);
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocBuilder<NotesBloc, NotesState>(
          builder: (context, state) {
            return _buildNotesBody(state);
          },
        ),
      ),
    );
  }

  Widget _buildNotesBody(NotesState state) {
    switch (state) {
      case NotesEmpty():
        return DisplayText(text: _strInitialText);

      case NotesError():
        return DisplayText(text: state.message);

      case NotesLoading():
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(7.0),
            child: CircularProgressIndicator(),
          ),
        );

      case NotesLoaded():
        List<Note> notes = state.notes;
        return notes.isEmpty
            ? DisplayText(text: _strInitialText)
            : ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: notes.length,
              itemBuilder: (BuildContext context, int index) {
                return CustomNoteCard(
                  title: notes[index].title,
                  description: notes[index].description,
                  onDeletePressed: () {
                    context.read<NotesBloc>().add(
                      DeleteNoteEvent(id: notes[index].id),
                    );
                  },
                );
              },
            );
      default:
        return Container();
    }
  }
}
