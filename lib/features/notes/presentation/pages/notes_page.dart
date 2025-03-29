import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:practice_app/core/widgets/display_text.dart';
import 'package:practice_app/features/notes/presentation/bloc/notes_bloc.dart';
import 'package:practice_app/features/notes/presentation/bloc/notes_event.dart';
import 'package:practice_app/features/notes/presentation/bloc/notes_state.dart';
import 'package:practice_app/injection_container.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NotesBloc>()..add(GetAllNotesEvent()),
      child: NotesView(),
    );
  }
}

class NotesView extends StatelessWidget {
  final String _strCounter = 'Notes';
  final String _strInitialText = "Click on the + icon to add notes";

  const NotesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).pop(),
        ),
        title: Text(_strCounter),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your action here
        },
        child: Icon(Icons.add), // Replace with any icon
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<NotesBloc, NotesState>(
                builder: (context, state) {
                  return _buildNotesBody(state);
                },
              ),
            ],
          ),
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
        return const CircularProgressIndicator(padding: EdgeInsets.all(7));
      case NotesLoaded():
        return Container();
      default:
        return Container();
    }
  }
}
