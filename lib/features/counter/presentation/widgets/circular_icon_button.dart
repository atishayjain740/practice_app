import 'package:flutter/material.dart';

class CircularIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  const CircularIconButton({super.key, required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
   return ElevatedButton(onPressed: onPressed, style: ElevatedButton.styleFrom(
    shape: CircleBorder(),
    padding: EdgeInsets.all(20),
  ), child: Icon(icon),);
  }
}