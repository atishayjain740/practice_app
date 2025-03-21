import 'package:flutter/material.dart';

class DisplayText extends StatelessWidget {
  final String text;
  const DisplayText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize: 35));
  }
}