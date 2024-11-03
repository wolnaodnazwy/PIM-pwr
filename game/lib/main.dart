import 'package:flutter/material.dart';
import 'package:game/first_page/first_page_main.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF65558F),
        scaffoldBackgroundColor: Colors.white,
        //useMaterial3: true,
      ),
      home: const GuessNumberScreen(),
    );
  }
}

