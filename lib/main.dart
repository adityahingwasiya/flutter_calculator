import 'package:calculator/provider/theme_provider.dart';
import 'package:calculator/screen/calculatorScreen.dart';
import 'package:calculator/screen/calculator_screen_adv.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



void main() {
  runApp(
    ChangeNotifierProvider(
        create:(_)=> ThemeProvider(),
      child: const MyApp(),
    )
  );
}
final ThemeData theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 100, 75, 37),
    brightness: Brightness.light
  ),
  useMaterial3: true,

);
final ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 169, 138, 61),
    brightness: Brightness.dark,
  ),
  useMaterial3: true,

);
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: theme,
      darkTheme: darkTheme,
      home:  CalculatorScreenAdv(),
    );
  }
}
