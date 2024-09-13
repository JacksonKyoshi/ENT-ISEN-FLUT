import 'package:flutter/material.dart';

import '../model/absences.dart';
import '../services/api_service.dart';
import '../services/token_service.dart';


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
              final List<Absence> absences = snapshot.data!;

              if (absences.isEmpty) {
                return Center(
                  child: Text("Aucune absence enregistrée", style: Theme.of(context).textTheme.bodyLarge)
                );
              }

              return ListView.builder(
                itemCount: absences.length,
                itemBuilder: (context, index) {
                  Absence absence = absences[index];
                  return Container(
                    decoration: const BoxDecoration(
                      border: Border(top: BorderSide(), bottom: BorderSide())
                    ),
                    child: ListTile(
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width/3.5,
                              child: Column(
                                children: [
                                  Icon(
                                      Icons.description,
                                      size: 48,
                                      color: absence.reason.contains("justifiée") ? Colors.green :
                                      absence.reason.contains("non excusée") ? Colors.red :
                                      Colors.lightGreen
                                  ),
                                  const Text("Absence"),
                                  Text(
                                      absence.reason.replaceAll("Absence ", ""),
                                      style: TextStyle(
                                          color: absence.reason.contains("justifiée") ? Colors.green :
                                          absence.reason.contains("non excusée") ? Colors.red :
                                          Colors.lightGreen,
                                          fontSize: 16
                                      )
                                  )
                                ],
                              )
                            ),
                            Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                    children: [
                                      Icon(Icons.calendar_month),
                                      Text(absence.date)
                                    ]
                                ),
                                Row(
                                    children: [
                                      Icon(Icons.timer),
                                      Text(absence.hours)
                                    ]
                                ),
                                Row(
                                    children: [
                                      Icon(Icons.person),
                                      Text(absence.teachers.join(", "))
                                    ]
                                ),
                                Row(
                                    children: [
                                      Icon(Icons.subject),
                                      Text(absence.subject)
                                    ]
                                ),
                              ],
                            ))
                          ],
                        )
                    )
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
