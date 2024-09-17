import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'calendar_screen.dart';
import '../model/absences.dart';
import 'absences/absence_screen.dart';
import '../services/User_service.dart';
import '../services/calendar_service.dart';
import '../model/notation.dart';
import 'notes/note_screen.dart';
import '../services/api_service.dart';
import '../services/token_service.dart';
import '../widgets/hamburger_menu.dart';
import 'dart:async';
import '../services/ics_parser.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService =
      ApiService('https://api-ent.isenengineering.fr');

  late Future<List<Notation>> _notationsFuture;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    String token = TokenManager.getInstance().getToken();
    print('répoonse $token');
    _notationsFuture = apiService.fetchNotations(token);
    Provider.of<CalendarEventProvider>(context, listen: false)
        .fetchEvents(UserManager.getInstance().getUsername().toLowerCase())
        .then((_) => setupCurrentEvent());
  }

  void setupCurrentEvent() {
    var calendarEvents =
        Provider.of<CalendarEventProvider>(context, listen: false).events;
    if (calendarEvents != null && calendarEvents.isNotEmpty) {
      CalendarEvent? currentEvent = calendarEvents.firstWhere(
          (event) =>
              event.start!.isBefore(DateTime.now()) &&
              event.end!.isAfter(DateTime.now()),
          orElse: () => CalendarEvent(
                summary: 'no event',
                description: {},
                start: DateTime.now(),
                end: DateTime.now(),
                location: null,
                url: null,
                attendees: null,
                organizer: null,
              ));
      if (currentEvent != null) {
        var duration = currentEvent.end!.difference(DateTime.now());
        _timer = Timer(
            duration,
            () => Provider.of<CalendarEventProvider>(context, listen: false)
                .fetchEvents(
                    UserManager.getInstance().getUsername().toLowerCase()));
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Dispose the timer when the widget is disposed
    super.dispose();
  }

  double calculateProgress(CalendarEvent event) {
    DateTime now = DateTime.now();
    double totalDuration =
        event.end!.difference(event.start!).inMinutes.toDouble();
    double elapsedDuration = now.difference(event.start!).inMinutes.toDouble();
    return elapsedDuration / totalDuration;
  }

  @override
  Widget build(BuildContext context) {
    var calendarEvents = Provider.of<CalendarEventProvider>(context).events;
    CalendarEvent? currentEvent;
    if (calendarEvents != null && calendarEvents.isNotEmpty) {
      currentEvent = calendarEvents.firstWhere(
        (event) => (event.start!.isBefore(DateTime.now()) &&
            event.end!.isAfter(DateTime.now())),
        orElse: () => CalendarEvent(
          summary: 'Pas de cours en cours',
          description: {},
          start: DateTime.now(),
          end: DateTime.now(),
          location: null,
          url: null,
          attendees: null,
          organizer: null,
        ),
      );
    }
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          //large text
          SizedBox(
            width: double.infinity,
            child: Container(
              padding: const EdgeInsets.all(16),
              child:
                  //capitalize the first letter each word in the username
                  Text(
                'Bonjour ${UserManager.getInstance().getUsername().split('.')[0].split(' ').map((String word) => word[0].toUpperCase() + word.substring(1)).join(' ')}',
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.left,
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Container(
              child: Column(
                children: [
                  Text(
                    'Prochains cours :',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.left,
                  ),
                  //place holder box
                  Container(
                    height: 200,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Container(
              child: Column(
                children: [
                  Text(
                    'Dernières notes :',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.left,
                  ),
                  //place holder box
                  Container(
                    height: 200,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Container(
              child: Column(
                children: [
                  Text(
                    'Dernières absences :',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.left,
                  ),
                  //place holder box
                  Container(
                    height: 200,
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}