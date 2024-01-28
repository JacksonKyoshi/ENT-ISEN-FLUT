// screens/home_screen.dart
import 'dart:convert';

import 'package:flutter/material.dart';

import '../main.dart';
import '../model/notation.dart';
import '../notesscreen/note_screen.dart';
import '../services/api_service.dart';
import '../services/ics_parser.dart';
import '../widgets/hamburger_menu.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final ApiService apiService = ApiService('https://api.isen-cyber.ovh');
  late MyApp myAppInstance;

  Future<String>? json_calendar;

  @override
  void initState() {
    super.initState();
    myAppInstance = MyApp();
    json_calendar = myAppInstance.testIcsParser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //white text color
        foregroundColor: Colors.white,
        title: const Text('ENT ISEN Toulon'),
        backgroundColor: Colors.red,
      ),
      drawer: const HamburgerMenu(),
      body: Center(
        child: FutureBuilder<String>(
          future: json_calendar,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Date: ${snapshot.data}'),
                    subtitle: Text('Code: ${snapshot.data}')
                    // Add more details if needed
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}