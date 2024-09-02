import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/api_service.dart';
import '../../services/token_service.dart';
import '../../widgets/day_view.dart';
import '../../widgets/event_detail.dart';
import '../../widgets/week_view.dart';
import '../../model/calendar_event.dart';

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

  @override
  void initState() {
    super.initState();
    selectedDay = DateTime.now(); // Set selectedDay to the current day
    updateCalendarEvents();
  }

  void updateCalendarEvents() {
    _calendarFuture = apiService.fetchCalendar(
        token,
        DateTime(selectedDay.year, selectedDay.month, selectedDay.day),
        DateTime(selectedDay.year, selectedDay.month, selectedDay.day, 23, 59)
    );
  }

  void onToday() {
    setState(() {
      selectedDay = DateTime.now();
      updateCalendarEvents();
    });
  }

  Future<void> onSelectDay() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDay,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2030),
      locale: const Locale("fr", "FR")
    );
    if (picked != null && picked != selectedDay) {
      setState(() {
        selectedDay = picked;
        updateCalendarEvents();
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
        updateCalendarEvents();
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
        updateCalendarEvents();
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
      updateCalendarEvents();
    });
  }

  void onEventSelected(CalendarEvent event) {
    setState(() {
      selectedEvent = event;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<CalendarEvent>>(
        future: _calendarFuture,
        builder: (context, snapshot) {
          Widget aboveDatePicker;
          if (snapshot.connectionState == ConnectionState.waiting) {
            aboveDatePicker = const Center(child:SizedBox(width: 50, height: 50, child: CircularProgressIndicator()));
          } else if (snapshot.hasError) {
            aboveDatePicker = Center(child: Text('Error: ${snapshot.error}'));
          } else {
          List<CalendarEvent> events = snapshot.data ?? [];

          aboveDatePicker = DayView(
              date: selectedDay,
              onEventSelected: onEventSelected,
              events: events,
            );
          }

          return Column(
            children: <Widget>[
              Expanded(
                  flex:
                  2, // Increase this value to give more space to the day view
                  child: aboveDatePicker
              ),
              if (selectedEvent != null)
                Container(
                  constraints:
                      const BoxConstraints(maxHeight: 300), // Set a maximum height
                  child: EventDetailView(event: selectedEvent!),
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
