// main.dart
import 'package:ent/services/token_service.dart';
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
    String retrievedToken = TokenManager.getInstance().getToken();

    print('Token: $retrievedToken');

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