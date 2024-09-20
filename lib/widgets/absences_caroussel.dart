
import 'package:ent/model/absences.dart';
import 'package:flutter/material.dart';

class AbsencesCaroussel extends StatelessWidget {
  final List<Absence> absences;

  const AbsencesCaroussel({super.key, required this.absences});

  //only keep the 5 most recent unexcused absences to display
  List<Absence> getRecentAbsences() {
    //sort absences by date
    List<Absence> sortedAbsences = List.from(absences);
    //keep only the unexcused absences
    sortedAbsences = sortedAbsences.where((absence) => absence.reason == "Absence non excusée").toList();
    sortedAbsences.sort((a, b) => a.date.compareTo(b.date));
    //reverse the list to have the most recent absences first
    sortedAbsences = sortedAbsences.reversed.toList();
    //keep only the 5 most recent absences
    if (sortedAbsences.length > 5) {
      sortedAbsences = sortedAbsences.sublist(0, 5);
    }
    return sortedAbsences;
  }

  @override
  Widget build(BuildContext context) {
    List<Absence> recentAbsences = getRecentAbsences();
    if (recentAbsences.isEmpty) {
      return Center(
        child: Text(
          'Pas d\'absences non excusées',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      );
    }
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height / 5,
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: getRecentAbsences().length,
        itemBuilder: (context, index) {
          Absence absences = getRecentAbsences()[index];
          return Container(
            width: MediaQuery.of(context).size.width / 1.5,
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    absences.date,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    absences.course,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      absences.duration,
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}