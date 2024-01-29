import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeekView extends StatelessWidget {
  final ValueChanged<DateTime> onDaySelected;
  final DateTime selectedDay;
  final ScrollController scrollController = ScrollController();
  final double arrowWidth = 50; // Adjust this value as needed

  WeekView({required this.onDaySelected, required this.selectedDay});

  @override
  Widget build(BuildContext context) {
    DateTime originalSelectedDay = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
    DateTime startOfWeek = selectedDay.subtract(Duration(days: selectedDay.weekday - 1));

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      double maxScrollExtent = scrollController.position.maxScrollExtent;
      double dayWidth = 120;// Divide by 7 as there are 7 days in a week
      double selectedDayPosition = dayWidth * (originalSelectedDay.weekday - 1); // weekday starts from 1 (Monday)
      double centerPosition = maxScrollExtent / 2;
      double scrollToPosition = selectedDayPosition - centerPosition + (3*(dayWidth/2)); // Adjust to center the selected day
      if (scrollToPosition < 0) scrollToPosition = 0;
      if (scrollToPosition > maxScrollExtent) scrollToPosition = maxScrollExtent;

      scrollController.animateTo(
        scrollToPosition,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    });

    return Container(
      height: 75, // Adjust this value as needed
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, index) {
          DateTime thisDay = startOfWeek.add(Duration(days: index));
          bool isSelected = thisDay.day == originalSelectedDay.day &&
                            thisDay.month == originalSelectedDay.month &&
                            thisDay.year == originalSelectedDay.year;

          return Container(
            width: 120, // Adjust this value as needed
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: isSelected ? Colors.grey : null,
            ),
            child: ListTile(
              title: Text(
                DateFormat('MMM\nEEE dd').format(thisDay),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20), // Set a maximum initial font size
                maxLines: 2,
              ),
              onTap: () => onDaySelected(thisDay),
            ),
          );
        },
      ),
    );
  }
}