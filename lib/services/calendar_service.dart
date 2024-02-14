import 'package:flutter/material.dart';
import '../services/ics_parser.dart';

class CalendarEventProvider with ChangeNotifier {
  List<CalendarEvent>? _events;

  List<CalendarEvent>? get events => _events;

  fetchEvents(String login) async {
    _events = await IcsParser.parse(login);
    notifyListeners();
  }
}