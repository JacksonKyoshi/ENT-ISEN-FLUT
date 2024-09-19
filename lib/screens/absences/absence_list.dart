import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../model/absences.dart';
import '../../widgets/custom_card_list.dart';

class AbsenceList extends StatelessWidget {
  const AbsenceList({super.key, required this.absences});

  final List<Absence> absences;

  Color defineAbsenceColor(Absence absence) {
    return absence.reason.toLowerCase().contains("justifiée") ? Colors.green :
            absence.reason.toLowerCase().contains("non excusée") ? Colors.red :
            Colors.lightGreen;
  }

  @override
  Widget build(BuildContext context) {
    if (absences.isEmpty) {
      return Center(
          child: Text("Aucune absence enregistrée", style: Theme.of(context).textTheme.bodyLarge)
      );
    }

    return ListView.builder(
      itemCount: absences.length,
      itemBuilder: (context, index) {
        Absence absence = absences[index];
        return CustomCardList(
          constraints: BoxConstraints(maxHeight: 110),
          leadingColor: defineAbsenceColor(absence),
          leading: Text(
            absence.date.substring(0, absence.date.lastIndexOf("/")),
            style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          title: AutoSizeText(
            absence.course,
            style: TextStyle(fontSize: 20.0,fontWeight:FontWeight.bold),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                absence.hours.replaceAll(":", "h"),
                style: TextStyle(
                    fontSize: 14.0, color: Color(0xFF555555)),
              ),
              Text(
                absence.reason,
                style: TextStyle(
                    fontSize: 14.0, color: defineAbsenceColor(absence)),
              )
            ]
          ),
          trailing: Text(
            absence.duration.replaceAll(":", "h"),
            style: TextStyle(
                fontSize: 24.0, fontWeight: FontWeight.bold, color: defineAbsenceColor(absence)),
          ),
          onTap: () {  },
        );
      },
    );
  }
}