import 'package:flutter/material.dart';

import '../../model/absences.dart';
import '../../services/api_service.dart';
import '../../services/token_service.dart';
import 'absence_list.dart';


class AbsenceView extends StatefulWidget {
  const AbsenceView({Key? key}) : super(key: key);

  @override
  _AbsenceViewState createState() => _AbsenceViewState();
}

class _AbsenceViewState extends State<AbsenceView> {
  final ApiService apiService = ApiService('https://api-ent.isenengineering.fr');

  late Future<List<Absence>> _absenceFuture;

  @override
  void initState() {
    super.initState();
    String token=TokenManager.getInstance().getToken();
    _absenceFuture = apiService.fetchAbsence(token);
  }

  List<double> _countAbsencesHours(List<Absence> absences) {
    /*
    counter is a counter for these values:
    0: all - every single absences hours
    1: justified - only justified absences
    2: excused - only excused absences
    3: unexcused - only unexcused absences
     */
    List<double> counter = [0.0, 0.0, 0.0, 0.0];

    for (Absence absence in absences) {
      List<String> parsedDuration = absence.duration.split(":");
      double durationHours = double.parse(parsedDuration[0]);
      double durationMinutes = double.parse(parsedDuration[1]);
      double duration = durationHours + durationMinutes/60.0;

      counter[0] += duration;

      switch(absence.reason) {
        case "Absence justifiée":
          counter[1] += duration;
          break;
        case "Absence excusée":
          counter[2] += duration;
          break;
        case "Absence non excusée":
          counter[3] += duration;
          break;
      }
    }

    return counter;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: FutureBuilder<List<Absence>>(
          future: _absenceFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<Absence> absences = snapshot.data!;
              List<double> absencesHours = _countAbsencesHours(absences);

              return Column(
                children: [
                    Card(
                      child: ExpansionTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                                absencesHours[0].floor() == 0 ? "0h" :
                                "${absencesHours[0].floor()}h${(((absencesHours[0]/absencesHours[0].floor() - 1.0) * 60.0).floor()).toString().padLeft(2, '0')}",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 32
                                )
                            ),
                            Text(" d'absences", style: TextStyle(fontSize: 20))
                          ]
                        ),
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                    absencesHours[1].floor() == 0 ? "0h" :
                                    "${absencesHours[1].floor()}h${(((absencesHours[1]/absencesHours[1].floor() - 1.0) * 60.0).floor()).toString().padLeft(2, '0')}",
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 20
                                    )
                                ),
                                Text(" d'absences justifiées", style: TextStyle(fontSize: 16))
                              ]
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                    absencesHours[2].floor() == 0 ? "0h" :
                                    "${absencesHours[2].floor()}h${(((absencesHours[2]/absencesHours[2].floor() - 1.0) * 60.0).floor()).toString().padLeft(2, '0')}",
                                    style: TextStyle(
                                        color: Colors.lightGreen,
                                        fontSize: 20
                                    )
                                ),
                                Text(" d'absences excusées", style: TextStyle(fontSize: 16))
                              ]
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                    absencesHours[3].floor() == 0 ? "0h" :
                                    "${absencesHours[3].floor()}h${(((absencesHours[3]/absencesHours[3].floor() - 1.0) * 60.0).floor()).toString().padLeft(2, '0')}",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 20
                                    )
                                ),
                                Text(" d'absences non excusées", style: TextStyle(fontSize: 16))
                              ]
                          ),
                        ],
                      )
                    ),
                    Expanded(
                      child: AbsenceList(absences: absences)
                    )
                  ]
              );
            }
          },
        ),
      ),
    );
  }
}
