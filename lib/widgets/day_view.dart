import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/calendar_event.dart';
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
            style: Theme.of(context).textTheme.headlineSmall,
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
                 event.title.toLowerCase().contains('projet') ? Icons.bar_chart :
                 event.title.toLowerCase().contains('travaux dirigés') ? Icons.calculate :
                 event.title.toLowerCase().contains('travaux pratiques') ? Icons.memory :
                 event.title.toLowerCase().contains('cours magistral') ? Icons.mic :
                 event.title.toLowerCase().contains('ds') ? Icons.school :
                 event.title.toLowerCase().contains('examen') ? Icons.school :
                 event.title.toLowerCase().contains('rattrapage') ? Icons.school :
                 event.title.toLowerCase().contains('réunion') ? Icons.people :
                 event.title.toLowerCase().contains('révisions') ? Icons.content_paste :
                  Icons.event,
               ),
            title: Text(
              '${DateFormat('HH:mm').format(event.start)} - ${DateFormat('HH:mm').format(event.end)}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            subtitle: Text(
              event.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            onTap: () => onEventSelected(event),
          ));
        },
      );
    }
  }
}
