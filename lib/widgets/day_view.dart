import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/calendar_event.dart';
class DayView extends StatelessWidget {
  final DateTime date;
  final ValueChanged<CalendarEvent> onEventSelected;
  final List<CalendarEvent>
      events; // This should be a list of events for the selected day
  final Future<void> Function() onRefresh;

  DayView(
      {required this.date,
      required this.onEventSelected,
      required this.events,
      required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return LayoutBuilder(
        builder: (context, constraints) => RefreshIndicator(
          onRefresh: onRefresh,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight,
              ),
              child: Center(
                child: Text(
                  'Pas de cours aujourd\'hui',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          CalendarEvent event = events[index];
          List<String> eventDescriptions = event.title.split(" - ");
          /* by now this is the pattern in the title :
          0: start hour
          1: end hour
          2: subject
          3: teacher's name
          4: teacher's surname
          5: class room
          6: class type
          7: duration
          8: course id
          */
          return Container(
            height: MediaQuery.of(context).size.height/5,
              child: Card(
                child: ListTile(
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 0, MediaQuery.of(context).size.height/64),
                subtitle: Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            DateFormat('HH:mm').format(event.start),
                            style: Theme.of(context).textTheme.bodyLarge
                        ),
                        Text(
                            DateFormat('HH:mm').format(event.end),
                            style: Theme.of(context).textTheme.bodyLarge
                        ),
                      ]
                    ),
                    const VerticalDivider(color: Colors.purple, thickness: 4),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(Icons.subject, size: 26),
                              Expanded(
                                child: Text(
                                  eventDescriptions[2],
                                  overflow: TextOverflow.fade,
                                  style: Theme.of(context).textTheme.titleMedium
                                )
                              )
                            ],
                          ),

                          Visibility(
                            visible: eventDescriptions[3].isNotEmpty && eventDescriptions[4].isNotEmpty,
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.person),
                                Text('${eventDescriptions[3]} ${eventDescriptions[4]}')
                              ],
                            )
                          ),
                          Visibility(
                            visible: eventDescriptions[5].isNotEmpty,
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.location_on),
                                Text(eventDescriptions[5])
                              ],
                            )
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
                              Text(eventDescriptions[6])
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              onTap: () => onEventSelected(event),
          )));
        },
      );
    }
  }
}
