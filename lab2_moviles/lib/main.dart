import 'package:flutter/material.dart';
import 'package:lab2_moviles/setstate/screens/home_screen.dart';
import 'package:lab2_moviles/theme/app_theme.dart';
// Main de setState
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: AppTheme.light,
      home: const TodosScreen(),
    );
  }
}