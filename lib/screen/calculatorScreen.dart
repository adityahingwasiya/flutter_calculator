import 'package:calculator/main.dart';
import 'package:calculator/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:calculator/widget/result.dart';
import 'package:calculator/widget/calculator_button.dart';
import 'package:provider/provider.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String op1Str = '';
  String op2Str = '';
  String? operator;
  String displayText = 'Enter values';

  final Map<String, Function(double, double)> operations = {
    '+': (a, b) => a + b,
    '-': (a, b) => a - b,
    '×': (a, b) => a * b,
    '÷': (a, b) => b == 0 ? double.nan : a / b,
  };

  final List<String> buttons = [
    '7', '8', '9', '÷',
    '4', '5', '6', '×',
    '1', '2', '3', '-',
    'C', '0', '.', '+',
    '=', '⌫',
  ];

  bool _isOperator(String x) => ['÷', '×', '-', '+', '=',].contains(x);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title:  Text('Calculator',style: TextStyle(
          color: Theme.of(context).colorScheme.onSecondary
        ),),
      actions: [
        IconButton(
          color: Theme.of(context).colorScheme.onSecondary,
            onPressed: themeProvider.toggleThememode,
            icon: Icon(themeProvider.isDarkMode?Icons.dark_mode:Icons.light_mode,))
      ],
      backgroundColor: Theme.of(context).colorScheme.secondary,),
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
            child: Result(display: displayText),
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
        op1Str = '';
        op2Str = '';
        operator = null;
        displayText = 'Enter values';
      } else if (value == '⌫') {
        _handleBackspace();
      } else if (value == '=') {
        _calculateResult();
      } else if (_isOperator(value)) {
        if (op1Str.isNotEmpty) {
          operator = value;
        }
      } else {
        _handleNumberInput(value);
      }

      displayText = _getDisplayText();
    });
  }

  void _handleBackspace() {
    if (operator == null) {
      if (op1Str.isNotEmpty) {
        op1Str = op1Str.substring(0, op1Str.length - 1);
      }
    } else {
      if (op2Str.isNotEmpty) {
        op2Str = op2Str.substring(0, op2Str.length - 1);
      }
    }
  }

  void _handleNumberInput(String value) {
    if (value == '.' && ((operator == null && op1Str.contains('.')) || (operator != null && op2Str.contains('.')))) {
      return; // prevent multiple decimals
    }

    if (operator == null) {
      op1Str += value;
    } else {
      op2Str += value;
    }
  }

  void _calculateResult() {
    if (op1Str.isEmpty || op2Str.isEmpty || operator == null) return;

    final op1 = double.tryParse(op1Str) ?? 0;
    final op2 = double.tryParse(op2Str) ?? 0;

    final operation = operations[operator!];
    if (operation != null) {
      final result = operation(op1, op2);
      op1Str = result.toString();
      op2Str = '';
      operator = null;
    }
  }

  String _getDisplayText() {
    if (op1Str.isEmpty) return 'Enter values';
    return operator == null
        ? op1Str
        : '$op1Str $operator ${op2Str.isNotEmpty ? op2Str : ''}';
  }
}
