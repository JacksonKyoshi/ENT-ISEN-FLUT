import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:http/http.dart' as http;

class CalendarEvent {
  final String? summary;
  final Map<String, String> description;
  final DateTime? start;
  final DateTime? end;
  final String? location;
  final String? url;
  final List<String>? attendees;
  final String? organizer;

  CalendarEvent({
    required this.summary,
    required this.description,
    required this.start,
    required this.end,
    required this.location,
    required this.url,
    required this.attendees,
    required this.organizer,
  });

  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    IcsDateTime start = json['dtstart'];
    IcsDateTime end = json['dtend'];

    Map<String, String> description = {};
    if (json['description'] != null && json['description'] is String) {
      //remove all \n and split on '- '
      List<String> lines = json['description'].replaceAll('\\n', '').split('- ');
      for (var line in lines) {
        line = line.startsWith('-') ? line.substring(1) : line; // Remove leading '-'
        List<String> parts = line.split(':');
        if (parts.length == 2) {
          description[parts[0].trim()] = parts[1].trim();
        }
      }
      //replace \ by , in intervenant
      if (description['intervenant'] != null) {
        description['intervenant'] = description['intervenant']!.replaceAll(' /', ',');
      }
    }

    String? summary = json['summary'];
    if (summary != null) {
      summary = summary.replaceAll(' /', ',');
      summary = summary.replaceAll('\\n', '');
    }

    return CalendarEvent(
      summary: summary,
      description: description,
      start: start != null ? start.toDateTime() : null,
      end: end != null ? end.toDateTime() : null,
      location: null, // location is not present in the JSON
      url: null, // url is not present in the JSON
      attendees: null, // attendees is not present in the JSON
      organizer: null, // organizer is not present in the JSON
    );
  }
}

class IcsParser {
  static Future<List<CalendarEvent>> parse(String login) async {
    final String url = 'https://ent-toulon.isen.fr/webaurion/ICS/$login.ics';
    final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
    final String decodedString = utf8.decode(response.bodyBytes);
    return fromIcs(decodedString);
  }

  static List<CalendarEvent> fromIcs(String icsString) {
    var icalendar = ICalendar.fromString(icsString);
    var events = icalendar.data as List;
    List<CalendarEvent> calendarEvents = events.map((event) => CalendarEvent.fromJson(event)).toList();
    calendarEvents.sort((a, b) => a.start!.compareTo(b.start!));
    return calendarEvents;
  }
}