import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/calendar_service.dart';
import '../services/User_service.dart';
import '../widgets/day_view.dart';
import '../widgets/event_detail.dart';
import '../widgets/hamburger_menu.dart';
import '../widgets/week_view.dart';
import '../services/ics_parser.dart'; // Add this line

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedDay = DateTime.now();
  CalendarEvent? selectedEvent; // Now CalendarEvent should be recognized

  @override
  void initState() {
    super.initState();
    selectedDay = DateTime.now(); // Set selectedDay to the current day
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<CalendarEventProvider>(context, listen: false)
        .fetchEvents('pierre.geiguer');
  }

  void onToday() {
    setState(() {
      selectedDay = DateTime.now();
    });
  }

  Future<void> onSelectDay() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDay,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDay) {
      setState(() {
        selectedDay = picked;
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
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text('ENT ISEN Toulon'),
        backgroundColor: Colors.red,
      ),
      drawer: const HamburgerMenu(),
      body: Consumer<CalendarEventProvider>(
        builder: (context, calendarEventProvider, child) {
          List<CalendarEvent>? events = calendarEventProvider.events;
          if (events == null) {
            return const CircularProgressIndicator();
          } else {
            events = events
                .where((event) => isWithinSelectedWeek(event.start!))
                .toList();
            events.sort((a, b) => a.start!.compareTo(b.start!));


            return Column(
              children: <Widget>[
                const Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: onPreviousWeek,
                    ),
                    Expanded(
                      child: WeekView(
                        onDaySelected: onDaySelected,
                        selectedDay: selectedDay,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: onNextWeek,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: onToday,
                      //button + text + icon
                      child: const Row(
                        children: [
                          Icon(Icons.today),
                          Text(
                            '  Aujourd\'hui',
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: onSelectDay,
                      //button + text + icon
                      child: const Row(
                        children: [
                          Icon(Icons.calendar_month),
                          Text(
                            '  Choisir une date',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  flex:
                      2, // Increase this value to give more space to the day view
                  child: DayView(
                    date: selectedDay,
                    onEventSelected: onEventSelected,
                    events: events
                        .where((event) => event.start!.day == selectedDay.day)
                        .toList(),
                  ),
                ),
                if (selectedEvent != null)
                  Container(
                    constraints:
                        const BoxConstraints(maxHeight: 300), // Set a maximum height
                    child: EventDetailView(event: selectedEvent!),
                  ),
              ],
            );
          }
        },
      ),
    );
  }
}
