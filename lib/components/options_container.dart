import 'package:flutter/material.dart';

class OptionsContainer extends StatelessWidget {
  final String text;
  final Color borderColor;
  const OptionsContainer(
      {super.key, required this.text, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    print('Option: $text, BorderColor: $borderColor');
    return Container(
      height: 50,
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: 1.8),
          borderRadius: BorderRadius.circular(30)),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
              color: Colors.deepPurple[700],
              fontWeight: FontWeight.w500,
              fontSize: 16),
        ),
      ),
    );
  }
}
