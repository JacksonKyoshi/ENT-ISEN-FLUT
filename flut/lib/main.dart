// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/calendar_service.dart';
import 'homescreen/home_screen.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CalendarEventProvider(),
      child: MaterialApp(
        title: 'ENT ISEN Toulon',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          primarySwatch: Colors.red,
        ),
        home: HomeScreen(),
      ),
    );
  }
}