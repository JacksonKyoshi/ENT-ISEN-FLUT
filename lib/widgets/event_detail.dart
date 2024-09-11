import 'package:ent/model/calendar_event_details.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/calendar_event.dart';
import '../services/api_service.dart';
import '../services/token_service.dart';

class EventDetailMenu extends StatefulWidget {
  final CalendarEventDetails eventDetails;

  const EventDetailMenu({ Key? key, required this.eventDetails }): super(key: key);

  @override
  _EventDetailMenuState createState() => _EventDetailMenuState();

}

class _EventDetailMenuState extends State<EventDetailMenu> with TickerProviderStateMixin {
  late final TabController _tabController;

  late List<Widget> _screensList = [];

  @override
  void initState() {
    super.initState();
    _screensList = <Widget>[
      ListView(
          children: _buildDetailsList(widget.eventDetails.teachers, const Icon(Icons.person_pin))
      ),
      ListView(
          children: _buildDetailsList(widget.eventDetails.students, const Icon(Icons.person))
      ),
      ListView(
          children: _buildDetailsList(widget.eventDetails.groups, const Icon(Icons.groups))
      )
    ];
    _tabController = TabController(length: _screensList.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Widget> _buildDetailsList(List<String> items, Icon leadingIcon) {
    List<Widget> widgetList = <Widget>[];

    for (final String item in items) {
        widgetList.add(ListTile(
          leading: leadingIcon,
          title: Text(item)
        ));
    }

    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "Professeurs (${widget.eventDetails.teachers.length})"),
            Tab(text: "Étudiants (${widget.eventDetails.students.length})"),
            Tab(text: "Groupes (${widget.eventDetails.groups.length})"),
          ]
        ),
        Expanded(
              child: TabBarView(
                controller: _tabController,
                children: _screensList,
            )
          )
      ]
    );
  }
}

class EventDetailView extends StatefulWidget {
  final CalendarEvent event;

  const EventDetailView ({ Key? key, required this.event }): super(key: key);

  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetailView> {
  final ApiService apiService = ApiService('https://api-ent.isenengineering.fr');
  final String token = TokenManager.getInstance().getToken();

  late Future<CalendarEventDetails> _eventDetailsFuture;

  @override
  void initState() {
    super.initState();
    _eventDetailsFuture = apiService.fetchCalendarEventDetails(token, widget.event.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CalendarEventDetails>(
      future: _eventDetailsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                    width: 50, height: 50,
                    child: CircularProgressIndicator()
                ),
                const SizedBox(height: 10),
                Text("Chargement de l'événement ${widget.event.id}", textAlign: TextAlign.center),
              ]
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          CalendarEventDetails eventDetails = snapshot.data!;

          // this should mean there is no information loaded
          if (eventDetails.subject.isEmpty && eventDetails.rooms.isEmpty) {
            return Center(
              child: Text(
                  "Aucune information trouvée sur l'événement",
                  style: Theme.of(context).textTheme.bodyLarge
              )
            );
          } // else
          return Column(
              children: [
                SizedBox(
                    height: 100,
                    child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 0, 10),
                        child: Row(
                          children: [
                            const VerticalDivider(color: Colors.purple, thickness: 4),
                            const SizedBox(width: 10),
                            Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        '${DateFormat('HH:mm').format(widget.event.start)} - ${DateFormat('HH:mm').format(widget.event.end)}',
                                        style: const TextStyle(
                                          fontSize: 20
                                        )
                                    ),
                                    Text(
                                        eventDetails.subject,
                                        style: const TextStyle(
                                            fontSize: 20
                                        )
                                    )
                                  ],
                                )
                            )
                          ],
                      )
                  )
                ),
                const SizedBox(height: 10),
                if (eventDetails.description.isNotEmpty)
                  Row(
                    children: [
                      Icon(Icons.comment),
                      Text(eventDetails.description)
                    ],
                  ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(
                      eventDetails.type.toLowerCase().contains('projet') ? Icons.bar_chart :
                      eventDetails.type.toLowerCase().contains('travaux dirigés') ? Icons.calculate :
                      eventDetails.type.toLowerCase().contains('travaux pratiques') ? Icons.memory :
                      eventDetails.type.toLowerCase().contains('cours magistral') ? Icons.mic :
                      eventDetails.type.toLowerCase().contains('ds') ? Icons.school :
                      eventDetails.type.toLowerCase().contains('examen') ? Icons.school :
                      eventDetails.type.toLowerCase().contains('rattrapage') ? Icons.school :
                      eventDetails.type.toLowerCase().contains('réunion') ? Icons.people :
                      eventDetails.type.toLowerCase().contains('révisions') ? Icons.content_paste :
                      Icons.event,
                    ),
                    Text(eventDetails.type)
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.location_on),
                    Text(eventDetails.rooms.join(", "))
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.subject),
                    Text(eventDetails.courseName)
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.view_module),
                    Text(eventDetails.module)
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: EventDetailMenu(eventDetails: eventDetails)
                )
              ],
            );
        }
      },
    );
  }
}
