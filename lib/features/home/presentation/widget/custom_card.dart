import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String? description;
  final VoidCallback onPressed;
  const CustomCard({super.key, required this.title, required this.onPressed, this.description});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: InkWell(
        onTap: () => onPressed(),
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
                Text(description == null ? '' : description!, style: TextStyle(fontSize: 15)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}