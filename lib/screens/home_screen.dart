import 'package:ent/model/absences.dart';
import 'package:ent/widgets/absences_caroussel.dart';
import 'package:ent/widgets/next_events.dart';
import 'package:flutter/material.dart';
import '../model/notation.dart';
import '../services/User_service.dart';
import '../services/api_service.dart';
import '../services/token_service.dart';
import '../widgets/day_view.dart';
import 'dart:async';
import '../model/calendar_event.dart';
import '../widgets/notes_caroussel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService =
      ApiService('https://api-ent.isenengineering.fr');
  final String token = TokenManager.getInstance().getToken();

  DateTime selectedDay = DateTime.now();
  CalendarEvent? selectedEvent;

  late Future<List<CalendarEvent>> _calendarFuture = Future.value([]);

  late Future<List<Notation>> _notationsFuture;

  late Future<List<Absence>> _absencesFuture = Future.value([]);

  final double horizontalPadding = 16.0; // Define padding variable

  @override
  void initState() {
    super.initState();
    selectedDay = DateTime.now();
    debugPrint('selectedDay: $selectedDay');
    if (selectedDay.weekday == DateTime.sunday) {
      selectedDay = selectedDay.add(const Duration(days: 1));
    }
    updateCalendarEvents();
    _notationsFuture = apiService.fetchNotations(token);
    _absencesFuture = apiService.fetchAbsence(token);
  }

  void updateCalendarEvents() {
    setState(() {
      _calendarFuture = fetchEventsForWeek(selectedDay);
    });
  }

  Future<List<CalendarEvent>> fetchEventsForWeek(DateTime day,
      {int maxDays = 30, int currentDayCount = 0}) async {
    List<CalendarEvent> events = [];

    while (events.length < 2 && currentDayCount < maxDays) {
      List<CalendarEvent> weekEvents = await apiService.fetchCalendar(
        token,
        DateTime(day.year, day.month, day.day, day.hour, day.minute),
        DateTime(day.year, day.month, day.day, 23, 59)
            .add(const Duration(days: 7)),
      );

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

            // get the first two events that ends after the current time
            for (var event in events) {
              if (event.end.isAfter(DateTime.now())) {
                displayEvents.add(event);
              }
              if (displayEvents.length >= 2) {
                break;
              }
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  //large text
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(
                          horizontalPadding, 16, horizontalPadding, 0),
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
                    padding:
                        EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Prochains cours :',
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.left,
                        ),
                        GestureDetector(
                          onTap: () {
                            // TODO: Handle event selection inside NextEvents
                          },
                          child: Container(
                            constraints: BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height / (3.5),
                              minHeight: MediaQuery.of(context).size.height / 8,
                            ),
                            child: SingleChildScrollView(
                              child: NextEvents(events: displayEvents),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dernières notes :',
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.left,
                        ),
                        Container(
                          constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height / 8,
                          ),
                          child:
                          FutureBuilder<List<Notation>>(
                            future: _notationsFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child:
                                    Text('Erreur de chargement des données'));
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return Center(
                                    child: Text('Pas de notes disponibles',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall));
                              } else {
                                return NotesCaroussel(notes: snapshot.data!);
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dernières absences :',
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.left,
                        ),
                        Container(
                          constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height / 8,
                          ),
                          child:
                          FutureBuilder<List<Absence>>(
                            future: _absencesFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child:
                                    Text('Erreur de chargement des données'));
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return Center(
                                    child: Text('Pas d\'absences disponibles',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall));
                              } else {
                                return AbsencesCaroussel(absences: snapshot.data!);
                              }
                            },
                          ),
                        )
                      ],
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
