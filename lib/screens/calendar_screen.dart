import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../services/cache.dart';
import '../services/token_service.dart';
import '../widgets/day_view.dart';
import '../widgets/event_detail.dart';
import '../widgets/week_view.dart';
import '../model/calendar_event.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final ApiService apiService = ApiService('https://api-ent.isenengineering.fr');
  final String token = TokenManager.getInstance().getToken();

  DateTime selectedDay = DateTime.now();
  CalendarEvent? selectedEvent; // Now CalendarEvent should be recognized

  late Future<List<CalendarEvent>> _calendarFuture;

  String cacheFileName = "planning.cache";

  @override
  void initState() {
    super.initState();
    selectedDay = DateTime.now(); // Set selectedDay to the current day
    if (selectedDay.weekday == DateTime.sunday) {
      selectedDay = selectedDay.add(const Duration(days: 1));
    }
    updateCalendarEvents(false, DateTime(selectedDay.year, selectedDay.month, selectedDay.day), DateTime(selectedDay.year, selectedDay.month, selectedDay.day, 23, 59));
    updateCache();
  }

  bool isOnSelectedDay(DateTime date) {
    return date.isAfter(DateTime(selectedDay.year, selectedDay.month, selectedDay.day)) &&
        date.isBefore(DateTime(selectedDay.year, selectedDay.month, selectedDay.day, 23, 59));
  }

  bool isThisWeek(DateTime date) {
    DateTime now = DateTime.now();

    return date.isAfter(DateTime(now.year, now.month, now.day-1, 23, 59)) &&
          date.isBefore(DateTime(now.year, now.month, now.day+1, 0, 1).add(const Duration(days: 7)));
  }

  Future<List<CalendarEvent>> _retrieveDataFromCache(DateTime start, DateTime end) async {
    String? cacheValue = await readFromCache(cacheFileName);

    if (cacheValue == null) {
      throw PathNotFoundException;
    }

    List<dynamic> calendarJson = json.decode(cacheValue);
    List<CalendarEvent> cachedEvents = calendarJson.map((json) => CalendarEvent.fromJSON(json)).toList();
    if (cachedEvents.isEmpty) {
      updateCache();
      throw PathNotFoundException;
    }
    List<CalendarEvent> filteredEvents = cachedEvents.where((event) => isOnSelectedDay(event.start)).toList();
    return filteredEvents;
  }

  Future<List<CalendarEvent>> updateCalendarEvents(bool forceRefresh, DateTime start, DateTime end) {
    if (!forceRefresh && isThisWeek(start)) {
      return _calendarFuture = _retrieveDataFromCache(start, end).
      catchError((err) {
        if (err.toString().contains("PathNotFoundException")) {
          return updateCalendarEvents(true, start, end);
        }
        throw err;
      });
    }
    return _calendarFuture = apiService.fetchCalendar(token, start, end);
  }

  void updateCache() async {
    String cacheValue = await readFromCache(cacheFileName) ?? "";
    if (cacheValue.isNotEmpty) {
      List<dynamic> calendarJson = json.decode(cacheValue);
      List<CalendarEvent> calendarEvents = calendarJson.map((json) => CalendarEvent.fromJSON(json)).toList();
      if (calendarEvents.isNotEmpty) {
        if (isOnSelectedDay(calendarEvents.first.start)) {
          return;
        }
      }
    }
    DateTime oneWeekLater = selectedDay.add(const Duration(days: 7));
    apiService.fetchCalendar(
        token,
        DateTime(selectedDay.year, selectedDay.month, selectedDay.day),
        DateTime(oneWeekLater.year, oneWeekLater.month, oneWeekLater.day)
    ).then((cachedEvents) => {
      writeToCache(cacheFileName, json.encode(cachedEvents.map((el) => el.toJSON()).toList()))
    }, onError: (err) => {
      debugPrint("erreur lors de la récupération du cache")
    });
    return;
  }

  void onToday() {
    setState(() {
      selectedDay = DateTime.now();
      updateCalendarEvents(false, DateTime(selectedDay.year, selectedDay.month, selectedDay.day), DateTime(selectedDay.year, selectedDay.month, selectedDay.day, 23, 59));updateCalendarEvents(false, DateTime(selectedDay.year, selectedDay.month, selectedDay.day), DateTime(selectedDay.year, selectedDay.month, selectedDay.day, 23, 59));
    });
  }

  Future<void> onSelectDay() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDay,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2030),
      selectableDayPredicate: (DateTime time) => time.weekday != DateTime.sunday,
      locale: const Locale("fr", "FR")
    );
    if (picked != null && picked != selectedDay) {
      setState(() {
        selectedDay = picked;
        updateCalendarEvents(false, DateTime(selectedDay.year, selectedDay.month, selectedDay.day), DateTime(selectedDay.year, selectedDay.month, selectedDay.day, 23, 59));
      });
    }
  }

  bool isWithinSelectedWeek(DateTime date) {
    final startOfWeek = DateTime(selectedDay.year, selectedDay.month,
        selectedDay.day - selectedDay.weekday + 1);
    final endOfWeek = startOfWeek.add(const Duration(days: 7));

    return date.isAfter(startOfWeek) && date.isBefore(endOfWeek);
  }

  void onPreviousWeek() {
    if (selectedDay.isBefore(DateTime(2015, 8))) {
      selectedDay = DateTime(2015, 8);
    } else if (selectedDay.isAfter(DateTime(2030))) {
      selectedDay = DateTime(2030);
    } else {
      setState(() {
        selectedDay = selectedDay.subtract(const Duration(days: 1));
        if (selectedDay.weekday == DateTime.sunday) {
          selectedDay = selectedDay.subtract(const Duration(days: 1));
        }
        updateCalendarEvents(false, DateTime(selectedDay.year, selectedDay.month, selectedDay.day), DateTime(selectedDay.year, selectedDay.month, selectedDay.day, 23, 59));
      });
    }
  }

  void onNextWeek() {
    //if day is not in range of frist day or last day (2015, 8) and (2030)
    if (selectedDay.isBefore(DateTime(2015, 8))) {
      selectedDay = DateTime(2015, 8);
    } else if (selectedDay.isAfter(DateTime(2030))) {
      selectedDay = DateTime(2030);
    } else {
      setState(() {
        selectedDay = selectedDay.add(const Duration(days: 1));
        if (selectedDay.weekday == DateTime.sunday) {
          selectedDay = selectedDay.add(const Duration(days: 1));
        }
        updateCalendarEvents(false, DateTime(selectedDay.year, selectedDay.month, selectedDay.day), DateTime(selectedDay.year, selectedDay.month, selectedDay.day, 23, 59));
      });
    }
  }

  void onDaySelected(DateTime day) {
    setState(() {
      selectedDay = day;
      selectedEvent = null;
      //if day is not in range of frist day or last day (2015, 8) and (2030)
      if (selectedDay.isBefore(DateTime(2015, 8))) {
        selectedDay = DateTime(2015, 8);
      } else if (selectedDay.isAfter(DateTime(2030))) {
        selectedDay = DateTime(2030);
      }
      updateCalendarEvents(false, DateTime(selectedDay.year, selectedDay.month, selectedDay.day), DateTime(selectedDay.year, selectedDay.month, selectedDay.day, 23, 59));
    });
  }

  void onEventSelected(CalendarEvent event) {
    setState(() {
      selectedEvent = event;
      showModalBottomSheet(
          isScrollControlled: true,
          useRootNavigator: true,
          constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width, maxHeight: MediaQuery.of(context).size.height/1.5),
          context: context,
          builder: (BuildContext context) {
            return EventDetailView(event: event);
          });
      });
  }

  Future<void> onRefresh() {
    setState(() {
      updateCalendarEvents(true, DateTime(selectedDay.year, selectedDay.month, selectedDay.day), DateTime(selectedDay.year, selectedDay.month, selectedDay.day, 23, 59));
    });

    return _calendarFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<CalendarEvent>>(
        future: _calendarFuture,
        builder: (context, snapshot) {
          Widget aboveDatePicker;
          if (snapshot.connectionState == ConnectionState.waiting) {
            aboveDatePicker = const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 50, height: 50,
                        child: CircularProgressIndicator()
                      ),
                      SizedBox(height: 10),
                      Text(
                          "Chargement du planning de la journée",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20
                          )
                      ),
                      SizedBox(height: 5),
                      Text(
                          "La première requête peut prendre plus de temps que les autres",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontStyle: FontStyle.italic
                          )
                      )
                    ]
                );
          } else if (snapshot.hasError) {
            aboveDatePicker = LayoutBuilder(
              builder: (context, constraints) => RefreshIndicator(
                onRefresh: onRefresh,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: constraints.maxWidth,
                      minHeight: constraints.maxHeight,
                    ),
                    child: Center(child: Text('Error: ${snapshot.error}')),
                  ),
                ),
              ),
            );
          } else {
          List<CalendarEvent> events = snapshot.data ?? [];

          aboveDatePicker = RefreshIndicator(
              onRefresh: () => onRefresh(),
              child: DayView(
                date: selectedDay,
                onEventSelected: onEventSelected,
                events: events,
                onRefresh: onRefresh,
              ),
            );
          }

          return Column(
            children: <Widget>[
              Expanded(
                  flex:
                  2, // Increase this value to give more space to the day view
                  child: aboveDatePicker
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: onPreviousWeek,
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: onSelectDay,
                      child: Text(
                      "${DateFormat("E dd MMM yyyy", "fr-FR").format(selectedDay)}",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge
                      )
                    )
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: onNextWeek,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
