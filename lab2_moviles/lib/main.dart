import 'package:flutter/material.dart';
import 'package:lab2_moviles/screens/home_screen.dart';
import 'package:lab2_moviles/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mis Lugares',
      theme: AppTheme.light,
      home: const TodosScreen(),
    );
  }
}
