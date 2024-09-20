import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/calendar_event.dart';

class DayView extends StatelessWidget {
  final DateTime date;
  final ValueChanged<CalendarEvent> onEventSelected;
  final List<CalendarEvent> events;

  DayView({
    required this.date,
    required this.onEventSelected,
    required this.events,
  });

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
      return SingleChildScrollView(
        child: Column(
          children: events.map((event) {
            List<String> eventDescriptions = event.title.split(" - ");
            return Container(
              height: MediaQuery.of(context).size.height / 5,
              child: Card(
                child: ListTile(
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 0, MediaQuery.of(context).size.height / 64),
                  subtitle: Row(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('HH:mm').format(event.start),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            DateFormat('HH:mm').format(event.end),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: RotatedBox(
                          quarterTurns: 1,
                          child: LinearProgressIndicator(
                            value: DateTime.now().isBefore(event.start) ? 1 : DateTime.now().isAfter(event.end) ? 1 : DateTime.now().difference(event.start).inMinutes / event.end.difference(event.start).inMinutes,
                            backgroundColor: Colors.grey[200],
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                const Icon(Icons.subject, size: 26),
                                Expanded(
                                  child: Text(
                                    eventDescriptions[2],
                                    overflow: TextOverflow.fade,
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                              ],
                            ),
                            Visibility(
                              visible: eventDescriptions[3].isNotEmpty && eventDescriptions[4].isNotEmpty,
                              child: Row(
                                children: <Widget>[
                                  const Icon(Icons.person),
                                  Text('${eventDescriptions[3]} ${eventDescriptions[4]}'),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: eventDescriptions[5].isNotEmpty,
                              child: Row(
                                children: <Widget>[
                                  const Icon(Icons.location_on),
                                  Text(eventDescriptions[5]),
                                ],
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Icon(
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
                                Text(eventDescriptions[6]),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  onTap: () => onEventSelected(event),
                ),
              ),
            );
          }).toList(),
        ),
      );
    }
  }
}