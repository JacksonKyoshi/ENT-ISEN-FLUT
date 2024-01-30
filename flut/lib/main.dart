// main.dart
import 'package:flutter/material.dart';
import 'homescreen/home_screen.dart';
import 'loginscreen/LoginScreen.dart';

void main() {
  runApp(LoginApp());
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
      home:HomeScreen(),
    );
  }

}