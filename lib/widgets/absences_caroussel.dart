import 'package:ent/model/absences.dart';
import 'package:flutter/material.dart';

class AbsencesCaroussel extends StatelessWidget {
  final List<Absence> absences;

  const AbsencesCaroussel({super.key, required this.absences});

  Color defineAbsenceColor(Absence absence) {
    return absence.reason.toLowerCase().contains("justifiée") ? Colors.green :
    absence.reason.toLowerCase().contains("non excusée") ? Colors.red :
    Colors.lightGreen;
  }

  //only keep the 5 most recent unexcused absences to display
  List<Absence> getRecentAbsences() {
    //sort absences by date
    List<Absence> sortedAbsences = List.from(absences);
    // Sort the absences by reason and date to have the most recent unexcused absences first
    sortedAbsences.sort((a, b) {
      if (a.reason == 'Absence non excusée' &&
          b.reason != 'Absence non excusée') {
        return -1;
      } else if (a.reason == 'Absence non excusée' &&
          b.reason == 'Absence non excusée') {
        return b.date.compareTo(a.date);
      } else if (a.reason == 'Absence excusée' &&
          b.reason == 'Absence justifiée') {
        return -1;
      } else if (a.reason == 'Absence excusée' &&
          b.reason == 'Absence non excusée') {
        return 1;
      } else if (a.reason == 'Absence excusée' &&
          b.reason == 'Absence excusée') {
        return b.date.compareTo(a.date);
      } else if (a.reason == 'Absence justifiée' &&
          b.reason != 'Absence justifiée') {
        return 1;
      } else if (a.reason == 'Absence justifiée' &&
          b.reason == 'Absence justifiée') {
        return b.date.compareTo(a.date);
      } else {
        return 0;
      }
    });

    // Keep only the 5 most recent absences
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
          'Pas d\'absences récentes',
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
            child: Row(
              children: [
                Container(
                  width: 5.0,
                  decoration: BoxDecoration(
                    color: defineAbsenceColor(absences),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          // Display the date without the year
                          "${absences.date.substring(0, absences.date.lastIndexOf("/"))} - ${absences.reason}",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          absences.subject,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                            child: Text(
                              absences.duration.replaceAll(":", "h"),
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}