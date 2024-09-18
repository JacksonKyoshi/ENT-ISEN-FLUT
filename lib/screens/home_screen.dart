import 'package:ent/widgets/next_events.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'calendar_screen.dart';
import '../model/absences.dart';
import 'absences/absence_screen.dart';
import '../services/User_service.dart';
import '../services/api_service.dart';
import '../services/token_service.dart';
import '../widgets/day_view.dart';
import 'dart:async';
import '../model/calendar_event.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService('https://api-ent.isenengineering.fr');
  final String token = TokenManager.getInstance().getToken();

  DateTime selectedDay = DateTime.now();
  CalendarEvent? selectedEvent;

  late Future<List<CalendarEvent>> _calendarFuture = Future.value([]);

  @override
  void initState() {
    super.initState();
    selectedDay = DateTime.now();
    debugPrint('selectedDay: $selectedDay');
    if (selectedDay.weekday == DateTime.sunday) {
      selectedDay = selectedDay.add(const Duration(days: 1));
    }
    updateCalendarEvents();
  }

  void updateCalendarEvents() {
    setState(() {
      _calendarFuture = fetchEventsForWeek(selectedDay);
    });
  }

  Future<List<CalendarEvent>> fetchEventsForWeek(DateTime day, {int maxDays = 300, int currentDayCount = 0}) async {
    List<CalendarEvent> events = [];

    while (events.length < 2 && currentDayCount < maxDays) {
      List<CalendarEvent> weekEvents = await apiService.fetchCalendar(
        token,
        DateTime(day.year, day.month, day.day, day.hour, day.minute),
        DateTime(day.year, day.month, day.day, 23, 59).add(const Duration(days: 7)),
      ) as List<CalendarEvent>;

      events.addAll(weekEvents);
      currentDayCount += 7;
      day = day.add(const Duration(days: 7));
      debugPrint('currentDayCount: $currentDayCount');
      debugPrint('events.length: ${events.length}');
    }

    // Ensure the events list is unique
    events = events.toSet().toList();
    return events;
  }

  void onEventSelected(CalendarEvent event) {
    setState(() {
      selectedEvent = event;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<CalendarEvent>>(
        future: _calendarFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur de chargement des données'));
          } else {
            List<CalendarEvent> events = snapshot.data!;
            List<CalendarEvent> displayEvents = [];

            // Find the current event
            CalendarEvent? currentEvent;
            for (var event in events) {
              if (event.start!.isBefore(DateTime.now()) && event.end!.isAfter(DateTime.now())) {
                currentEvent = event;
                break;
              }
            }

            if (currentEvent != null) {
              displayEvents.add(currentEvent);
              // Add the next event after the current event
              for (var event in events) {
                if (event.start!.isAfter(currentEvent.end!)) {
                  displayEvents.add(event);
                  break;
                }
              }
            } else {
              // Add the next two events if there is no current event
              displayEvents = events.take(2).toList();
            }

            return Column(
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
                  Container(
                      child: Column(
                        children: [
                          Text(
                            'Prochains cours :',
                            style: Theme.of(context).textTheme.headlineMedium,
                            textAlign: TextAlign.left,
                          ),
                          SingleChildScrollView(
                          child: Container(
                            child: NextEvents(events: displayEvents),
                            ),
                          ),
                        ],
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
            );
          }
        },
      ),
    );
  }
}