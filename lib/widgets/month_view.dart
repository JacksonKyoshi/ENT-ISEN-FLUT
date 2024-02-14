import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthView extends StatelessWidget {
  final ValueChanged<DateTime> onDaySelected;

  MonthView({required this.onDaySelected});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    int weekdayOfFirstDay = firstDayOfMonth.weekday;
    int daysInMonth = DateTime(now.year, now.month + 1, 0).day;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
      ),
      itemCount: daysInMonth + weekdayOfFirstDay - 1,
      itemBuilder: (context, index) {
        int dayNumber = index - weekdayOfFirstDay + 2;
        if (dayNumber >= 1 && dayNumber <= daysInMonth) {
          DateTime thisDay = DateTime(now.year, now.month, dayNumber);
          return GestureDetector(
            onTap: () => onDaySelected(thisDay),
            child: FittedBox(
              child: Text(
                '$dayNumber',
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else {
          return Container(); // Empty container for days not in this month
        }
      },
    );
  }
}