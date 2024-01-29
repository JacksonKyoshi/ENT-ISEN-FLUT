import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/ics_parser.dart';

class EventDetailView extends StatelessWidget {
  final CalendarEvent event;

  EventDetailView({required this.event});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey[200],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: MediaQuery.of(context).size.width - 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Divider(color: Colors.grey), // This adds a delimiter on top
                Text(
                  event.summary ?? '',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(height: 8.0),
                Text(
                  'Start: ${event.start}',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Text(
                  'End: ${event.end}',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                SizedBox(height: 8.0),
                Text(
                  event.description.entries
                      .map((e) => '${e.key}: ${e.value}')
                      .join('\n'),
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
