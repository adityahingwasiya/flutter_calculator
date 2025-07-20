import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  final String display;
  const Result({super.key, required this.display});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Text(
        display,
        style:  TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onBackground,
        ),
        textAlign: TextAlign.right,
      ),
    );
  }
}
