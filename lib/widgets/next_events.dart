import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/calendar_event.dart';
import 'day_view.dart';

class NextEvents extends StatelessWidget {
  final List<CalendarEvent> events;

  const NextEvents({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return Center(
        child: Text(
          'Pas de cours prochainement',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      );
    }

    // Group events by day
    Map<DateTime, List<CalendarEvent>> groupedEvents = {};
    for (var event in events) {
      DateTime eventDate = DateTime(event.start.year, event.start.month, event.start.day);
      if (!groupedEvents.containsKey(eventDate)) {
        groupedEvents[eventDate] = [];
      }
      groupedEvents[eventDate]!.add(event);
    }

    // Convert the map to a list of date and events pairs
    List<MapEntry<DateTime, List<CalendarEvent>>> groupedEventsList = groupedEvents.entries.toList();

    return Column(
      children: groupedEventsList.map((entry) {
        DateTime date = entry.key;
        List<CalendarEvent> dayEvents = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('EEEE d MMMM', 'fr_FR').format(date),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height / (3.5), // Adjust the height as needed
              ),
              child: DayView(date: date, events: dayEvents, onEventSelected: (event){
                // Handle event selection
              }, onRefresh: () async {  },),
            ),
          ],
        );
      }).toList(),
    );
  }
}