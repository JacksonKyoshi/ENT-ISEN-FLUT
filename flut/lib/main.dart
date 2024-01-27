// main.dart
import 'dart:io';
import 'dart:convert';
import 'package:ent/services/ics_parser.dart';
import 'package:flutter/material.dart';
import 'package:icalendar_parser/icalendar_parser.dart';
import 'homescreen/home_screen.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ENT ISEN MOODLE',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }

  Future<String> testIcsParser() async {
    const path = 'https://ent-toulon.isen.fr/webaurion/ICS/pierre.geiguer.ics';
    //http get the ics file
    final icsFile = await http.get(Uri.parse(path));
    //parse the ics file
    final icsObj = ICalendar.fromString(icsFile.body);
    //get the events
    //save the Json to a file for debug
    //final file = File('lib/assets/ICS/ics.json');
    //await file.writeAsString(jsonEncode(icsObj.toJson()));
    return(jsonEncode(icsObj.toJson()));
  }
}