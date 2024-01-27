// main.dart
import 'dart:io';
import 'dart:convert';
import 'package:ent/services/ics_parser.dart';
import 'package:flutter/material.dart';
import 'package:icalendar_parser/icalendar_parser.dart';
import 'homescreen/home_screen.dart';

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

  void testIcsParser() {
    const path = 'lib/assets/pierre.geiguer.ics';
    final icsObj = ICalendar.fromLines(File(path).readAsLinesSync());
    print(jsonEncode(icsObj.toJson()));
    final events = (jsonDecode(jsonEncode(icsObj.toJson())) as List)
        .map((e) => CalendarEvent(
        e['summary'],
        e['description'],
        DateTime.parse(e['start']),
        DateTime.parse(e['end']),
        e['location'],
        e['url'],
        (e['attendees'] as List).map((e) => e.toString()).toList(),
        e['organizer']))
        .toList();
    print(events);
  }
}