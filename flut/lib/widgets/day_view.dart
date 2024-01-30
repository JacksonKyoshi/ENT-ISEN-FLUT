import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../calendar_screen/calendar_screen.dart';
import '../services/ics_parser.dart'; // Replace with your actual path

class DayView extends StatelessWidget {
  final DateTime date;
  final ValueChanged<CalendarEvent> onEventSelected;
  final List<CalendarEvent>
      events; // This should be a list of events for the selected day

  DayView(
      {required this.date,
      required this.onEventSelected,
      required this.events});

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return Container(
        child: Center(
          child: Text(
            'Pas de cours aujourd\'hui',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          CalendarEvent event = events[index];
          return Card(
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
            title: Text(
              '${DateFormat('HH:mm').format(event.start!)} - ${DateFormat('HH:mm').format(event.end!)}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            subtitle: Text(
              '${event.summary}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            onTap: () => onEventSelected(event),
          ));
        },
      );
    }
  }
}
