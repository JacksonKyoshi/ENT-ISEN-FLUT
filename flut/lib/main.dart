// main.dart
import 'package:flutter/material.dart';
import 'homescreen/home_screen.dart';

void main() {
  runApp(MyApp());
}
//test push
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ENT ISEN MOODLE',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}