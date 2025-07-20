import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  final String text;
  final bool isOperator;
  final VoidCallback onTap;

  const CalculatorButton({
    super.key,
    required this.text,
    required this.isOperator,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isOperator ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        onPressed: onTap,
        child: Text(
          text,
          style:  TextStyle(fontWeight: FontWeight.w700,fontSize: 24, color: isOperator ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSecondary,),
        ),
      ),
    );
  }
}
