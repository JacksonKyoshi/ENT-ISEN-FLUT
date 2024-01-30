import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../calendar_screen/calendar_screen.dart';
import '../services/calendar_service.dart';
import '../model/notation.dart';
import '../notesscreen/note_screen.dart';
import '../services/api_service.dart';
import '../widgets/hamburger_menu.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService('https://api.isen-cyber.ovh');

  late Future<List<Notation>> _notationsFuture;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _notationsFuture =
        apiService.fetchNotations('FAKETOKEN') as Future<List<Notation>>;
    Provider.of<CalendarEventProvider>(context, listen: false)
        .fetchEvents('pierre.geiguer');
    var calendarEvents =
        Provider.of<CalendarEventProvider>(context, listen: false).events;
    if (calendarEvents != null && calendarEvents.isNotEmpty) {
      var currentEvent = calendarEvents.firstWhere((event) =>
          event.start!.isBefore(DateTime.now()) &&
          event.end!.isAfter(DateTime.now()));
      if (currentEvent != null) {
        var duration = currentEvent.end!.difference(DateTime.now());
        _timer = Timer(
            duration,
            () => Provider.of<CalendarEventProvider>(context, listen: false)
                .fetchEvents('pierre.geiguer'));
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Dispose the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var calendarEvents = Provider.of<CalendarEventProvider>(context).events;
    return Scaffold(
      appBar: AppBar(
        //white text color
        foregroundColor: Colors.white,
        title: const Text('ENT ISEN Toulon'),
        backgroundColor: Colors.red,
      ),
      drawer: const HamburgerMenu(),
      body: SingleChildScrollView( // Add this
        child: Center(
          child: Container(
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
                      MaterialPageRoute(builder: (context) => NotesScreen()),
                    );
                  },
                  child: FutureBuilder<List<Notation>>(
                    future: _notationsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          width: MediaQuery.of(context).size.width - 30,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.blue.shade100,
                          ),
                          child: Column(
                            children: [
                              Text(snapshot.data![0].code),
                              Text(snapshot.data![0].note.toString(),
                                  style: const TextStyle(fontSize: 30)),
                            ],
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
                      MaterialPageRoute(builder: (context) => CalendarScreen()),
                    );
                  },
                  child: Column(
                    children: calendarEvents != null
                        ? calendarEvents!
                        .where((event) => event.start!.isBefore(DateTime.now()) && event.end!.isAfter(DateTime.now()) || event.start!.isAfter(DateTime.now()))
                        .take(2)
                        .map((event) => Card(
                      child: ListTile(
                        leading: Icon(
                          event.summary!.contains('PROJET') ? Icons.bar_chart :
                          event.summary!.contains('TD') ? Icons.calculate :
                          event.summary!.contains('TP') ? Icons.memory :
                          event.summary!.contains('CM') ? Icons.mic :
                          event.summary!.contains('DS') ? Icons.school :
                          event.summary!.contains('EXAMEN') ? Icons.school :
                          event.summary!.contains('RATTRAPAGE') ? Icons.school :
                          event.summary!.contains('REUNION') ? Icons.people :
                          Icons.event,
                        ),
                        title: Container(
                          width: MediaQuery.of(context).size.width - 30,
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${DateFormat('HH:mm').format(event.start!)} - ${DateFormat('HH:mm').format(event.end!)}',
                                textAlign: TextAlign.left,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Text('${event.summary}',
                                textAlign: TextAlign.left,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ))
                        .toList()
                        : [const CircularProgressIndicator()],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
