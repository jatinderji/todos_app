import 'package:flutter/material.dart';
import 'package:todos_app/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todos App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[200],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
        )
      ),
      home: const HomePage(),
    );
  }
}
