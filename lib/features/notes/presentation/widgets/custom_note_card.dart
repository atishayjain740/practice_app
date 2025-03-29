import 'package:flutter/material.dart';

class CustomNoteCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onDeletePressed;
  const CustomNoteCard({super.key, required this.title, required this.description, required this.onDeletePressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 20)),
              const SizedBox(height: 10,),
              Text(description, style: TextStyle(fontSize: 15)),
              const SizedBox(height: 10,),
              InkWell(
                onTap: onDeletePressed,
                child: Icon(Icons.delete))
            ],
          ),
        ),
      ),
    );
  }
}