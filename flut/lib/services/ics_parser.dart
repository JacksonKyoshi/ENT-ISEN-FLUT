
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:icalendar_parser/icalendar_parser.dart';

class CalendarEvent {
  String summary;
  String description;
  DateTime start;
  DateTime end;
  String location;
  String url;
  List<String> attendees;
  String organizer;

  CalendarEvent(
      this.summary,
      this.description,
      this.start,
      this.end,
      this.location,
      this.url,
      this.attendees,
      this.organizer);
}

class ics_parser {
  final String path;
  ics_parser(this.path);



}
