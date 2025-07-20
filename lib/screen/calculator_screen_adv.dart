import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:calculator/provider/theme_provider.dart';
import 'package:calculator/widget/result.dart';
import 'package:calculator/widget/calculator_button.dart';

class CalculatorScreenAdv extends StatefulWidget {
  const CalculatorScreenAdv({super.key});

  @override
  State<CalculatorScreenAdv> createState() => _CalculatorScreenAdvState();
}

class _CalculatorScreenAdvState extends State<CalculatorScreenAdv> {
  String displayText = '';

  final List<String> buttons = [
    '7', '8', '9', '÷',
    '4', '5', '6', '×',
    '1', '2', '3', '-',
    'C', '0', '.', '+',
    '=', '⌫',
  ];

  bool _isOperator(String x) => ['÷', '×', '-', '+', '='].contains(x);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calculator',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
        actions: [
          IconButton(
            color: Theme.of(context).colorScheme.onSecondary,
            onPressed: themeProvider.toggleThememode,
            icon: Icon(
              themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            ),
          )
        ],
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Column(
        children: [
          Container(
            height: 300,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            width: double.infinity,
            padding: const EdgeInsets.all(20.0),
            alignment: Alignment.bottomRight,
            child: Result(display: displayText.isEmpty ? 'Enter values' : displayText),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.surfaceContainer,
              child: GridView.builder(
                itemCount: buttons.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                ),
                itemBuilder: (context, index) {
                  return CalculatorButton(
                    text: buttons[index],
                    isOperator: _isOperator(buttons[index]) ||
                        buttons[index] == '=' ||
                        buttons[index] == 'C' ||
                        buttons[index] == '⌫',
                    onTap: () => _onButtonPressed(buttons[index]),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        displayText = '';
      } else if (value == '⌫') {
        if (displayText.isNotEmpty) {
          displayText = displayText.substring(0, displayText.length - 1);
        }
      } else if (value == '=') {
        _calculateResult();
      } else {
        displayText += value;
      }
    });
  }

  void _calculateResult() {
    try {
      String input = displayText.replaceAll('×', '*').replaceAll('÷', '/');
      Parser p = Parser();
      Expression exp = p.parse(input);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      displayText = eval.toString();
    } catch (e) {
      displayText = 'Error';
    }
  }
}
