import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'calendar/calendar_screen.dart';
import '../model/absences.dart';
import 'absence_screen.dart';
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
  final ApiService apiService = ApiService('https://api-ent.isenengineering.fr');

  late Future<List<Notation>> _notationsFuture;
  Timer? _timer;

  @override
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
        // Add this
        child: Center(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: const Text('Dernières notes :',
                      style: TextStyle(fontSize: 20)),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NotesScreen()),
                  );
                },
                child: FutureBuilder<List<Notation>>(
                  future: _notationsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Card(
                        // Wrap the Container with a Card
                        child: Container(
                          width: MediaQuery.of(context).size.width - 30,
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Text(snapshot.data![0].code),
                              Text(snapshot.data![0].note.toString(),
                                  style: const TextStyle(fontSize: 30)),
                            ],
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return const CircularProgressIndicator();
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: const Align(
                  alignment: Alignment.topLeft,
                  child:
                      Text('Prochains Cours :', style: TextStyle(fontSize: 20)),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CalendarScreen()),
                  );
                },
                child: Column(
                  children: calendarEvents != null
                      ? calendarEvents
                          .where((event) => event.end!.isAfter(DateTime.now()))
                          .take(2)
                          .map((event) => Card(
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width -
                                      30, // Set the width of the Container
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      ListTile(
                                        leading: Icon(
                                          event.summary!.contains('PROJET')
                                              ? Icons.bar_chart
                                              : event.summary!.contains('TD')
                                                  ? Icons.calculate
                                                  : event.summary!
                                                          .contains('TP')
                                                      ? Icons.memory
                                                      : event.summary!
                                                              .contains('CM')
                                                          ? Icons.mic
                                                          : event.summary!
                                                                  .contains(
                                                                      'DS')
                                                              ? Icons.school
                                                              : event.summary!
                                                                      .contains(
                                                                          'EXAMEN')
                                                                  ? Icons.school
                                                                  : event.summary!
                                                                          .contains(
                                                                              'RATTRAPAGE')
                                                                      ? Icons
                                                                          .school
                                                                      : event.summary!.contains(
                                                                              'REUNION')
                                                                          ? Icons
                                                                              .people
                                                                          : Icons
                                                                              .event,
                                        ),
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${DateFormat('HH:mm').format(event.start!)} - ${DateFormat('HH:mm').format(event.end!)}',
                                              textAlign: TextAlign.left,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge,
                                            ),
                                            Text(
                                              '${event.summary}',
                                              textAlign: TextAlign.left,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium,
                                            ),
                                            //if its the frist tile display the progress bar
                                            if (event == currentEvent)
                                              LinearProgressIndicator(
                                                value: calculateProgress(event),
                                                backgroundColor:
                                                    Colors.grey.shade400,
                                                valueColor:
                                                    const AlwaysStoppedAnimation<
                                                        Color>(Colors.red),
                                                minHeight: 10,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ))
                          .toList()
                      : [const CircularProgressIndicator()],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AbsenceView()),
                  );
                },
                child: FutureBuilder<List<Absence>>(
                  future: apiService.fetchAbsence(TokenManager.getInstance().getToken()),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      int totalAbsences = snapshot.data!.isEmpty
                          ? 0
                          : snapshot.data!
                          .map((absence) => int.parse(absence.hours))
                          .reduce((value, element) => value + element);
                    }
                    if (snapshot.hasData) {
                      int totalAbsences = snapshot.data!.length;
                      return Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              child: Text('Total Absences: $totalAbsences H', style: TextStyle(fontSize: 20)),
                            ),
                          ),
                          totalAbsences > 0
                              ? Container(
                            height: 200, // specify a height
                            child: ListView.builder(
                              itemCount: totalAbsences,
                              itemBuilder: (context, index) {
                                Absence absence = snapshot.data![index];
                                return Card(
                                  child: ListTile(
                                    title: Text('Date: ${absence.date}'),
                                    subtitle: Text('Course: ${absence.subject}\nHeures: ${absence.hours}\n${absence.reason}'),
                                    trailing: const Icon(Icons.arrow_forward),
                                  ),
                                );
                              },
                            ),
                          )
                              : Card(
                            child: ListTile(
                              title: Text('Aucune absences'),
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return CircularProgressIndicator();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
