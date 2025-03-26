import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  const CustomButton({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
   return SizedBox(
     width: MediaQuery.of(context).size.width,
     child: ElevatedButton(
                onPressed: onPressed,
                child: Text(text),
              ),
   );
  }
}