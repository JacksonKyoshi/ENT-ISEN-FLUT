// services/api_service.dart
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/notation.dart';
import '../model/absences.dart';
import '../model/notation_class.dart';
import '../model/calendar_event.dart';
import '../model/calendar_event_details.dart';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<List<Notation>> fetchNotations(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/v1/notations'),
      headers: {'Token': token},
    );

    if (response.statusCode == 200) {
      List<dynamic> notationsJson = json.decode(response.body);
      List<Notation> notations = notationsJson
          .map((json) => Notation.fromJson(json))
          .toList();

      return notations;
    } else {
      throw Exception('Failed to load notations');
    }
  }

  Future<List<NotationClass>> fetchNotationsClass(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/v1/notations/class'),
      headers: {'Token': token},
    );

    if (response.statusCode == 200) {
      List<dynamic> notationsJson = json.decode(response.body);
      List<NotationClass> notationsClass = notationsJson
          .map((json) => NotationClass.fromJson(json))
          .toList();
      return notationsClass;
    } else {
      throw Exception('Failed to load notations');
    }
  }

  Future<List<Absence>> fetchAbsence(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/v1/absences'),
      headers: {'Token': token},
    );

    if (response.statusCode == 200) {
      List<dynamic> absenceJson = json.decode(response.body);
      List<Absence> absence = absenceJson != null
          ? absenceJson.map((json) => Absence.fromJson(json)).toList()
          : [];
      absence.removeAt(0);
      return absence;
    } else {
      throw Exception('Failed to load absences');
    }
  }

  Future<List<CalendarEvent>> fetchCalendar(String token, DateTime start, DateTime end) async {
    final response = await http.get(
      Uri.parse('$baseUrl/v1/agenda?start=${start.millisecondsSinceEpoch}&end=${end.millisecondsSinceEpoch}'),
      headers: {'Token': token},
    );

    if (response.statusCode == 200) {
      List<dynamic> calendarJson = json.decode(response.body);
      List<CalendarEvent> calendarEvents = calendarJson.map((json) => CalendarEvent.fromJSON(json)).toList();
      return calendarEvents;
    } else {
      throw Exception('Failed to load calendar');
    }
  }

  Future<CalendarEventDetails> fetchCalendarEventDetails(String token, String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/v1/agenda/event/$id'),
      headers: {'Token': token},
    );

    if (response.statusCode == 200) {
      dynamic eventDetailsJson = json.decode(response.body);
      CalendarEventDetails eventDetails = CalendarEventDetails.fromJSON(eventDetailsJson);
      return eventDetails;
    } else {
      throw Exception('Failed to load calendar event');
    }
  }
}
