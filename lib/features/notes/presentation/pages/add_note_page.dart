import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:practice_app/core/widgets/custom_button.dart';
import 'package:practice_app/core/widgets/custom_text_form_field.dart';
import 'package:practice_app/features/notes/presentation/bloc/notes_bloc.dart';
import 'package:practice_app/features/notes/presentation/bloc/notes_event.dart';

class AddNotePage extends StatelessWidget {
  final String _strAddNote = 'Add Note';
  final String _strTitleHintText = 'Enter title';
  final String _strDescriptionHintText = 'Enter description';
  final String _strTitleValidationError = 'Please enter title';
  final String _strDescriptionValidationError = 'Please enter description';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titlecontroller = TextEditingController();
  final TextEditingController _descriptioncontroller = TextEditingController();

  AddNotePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).pop(),
        ),
        title: Text(_strAddNote),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextFormField(
                      controller: _titlecontroller,
                      hintText: _strTitleHintText,
                      validator: (value) {
                        if (value!.isEmpty) return _strTitleValidationError;
                        return null;
                      },
                    ),
                    CustomTextFormField(
                      controller: _descriptioncontroller,
                      hintText: _strDescriptionHintText,
                      maxlines: 8,
                      validator: (value) {
                        if (value!.isEmpty) return _strDescriptionValidationError;
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              CustomButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<NotesBloc>().add(
                      AddNoteEvent(
                        title: _titlecontroller.text.toString().trim(),
                        description:
                            _descriptioncontroller.text.toString().trim(),
                      ),
                    );

                    GoRouter.of(context).pop();
                  }
                },
                text: _strAddNote,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
