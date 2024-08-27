import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/calendar_event.dart';

class EventDetailView extends StatelessWidget {
  final CalendarEvent event;

  EventDetailView({required this.event});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.red[50],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: MediaQuery.of(context).size.width - 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Divider(color: Colors.grey), // This adds a delimiter on top
                Text(
                  event.className,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Cours du: ${DateFormat('dd MMM y').format(event.start)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  'De: ${DateFormat('HH:mm').format(event.start)} à ${DateFormat('HH:mm').format(event.end)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8.0),
                Text(
                  event.title.replaceAll('-', '\n'),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
