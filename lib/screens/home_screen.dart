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
      _calendarFuture = fetchEventsForDay(selectedDay);
    });
  }

  Future<List<CalendarEvent>> fetchEventsForDay(DateTime day, {int maxDays = 30, int currentDayCount = 0}) async {
    if (currentDayCount >= maxDays) {
      return [];
    }

    List<CalendarEvent> events = await apiService.fetchCalendar(
      token,
      DateTime(day.year, day.month, day.day),
      DateTime(day.year, day.month, day.day, 23, 59)
    ) as List<CalendarEvent>;

    if (events.length < 2 && currentDayCount < maxDays) {
      // If no events for the current day, fetch for the next week and add to the current list
      // Number of days to fetch is maxDays - currentDayCount
      debugPrint('No events for $day, fetching for the next week');
      currentDayCount += 7;
      List<CalendarEvent> nextEvents = await fetchEventsForDay(day.add(const Duration(days: 1)), maxDays: maxDays, currentDayCount: currentDayCount + 1);
      events.addAll(nextEvents);
    }
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

            return SingleChildScrollView(
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
                    height: 200,
                    child: Container(
                      child: Column(
                        children: [
                          Text(
                            'Prochains cours :',
                            style: Theme.of(context).textTheme.headlineMedium,
                            textAlign: TextAlign.left,
                          ),
                          // Display current event + next one or next 2 events
                          Expanded(
                            child: DayView(
                              date: selectedDay,
                              onEventSelected: onEventSelected,
                              events: displayEvents,
                            ),
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
              ),
            );
          }
        },
      ),
    );
  }
}