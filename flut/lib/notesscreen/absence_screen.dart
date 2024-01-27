import 'package:flutter/material.dart';

import '../model/absences.dart';
import '../services/api_service.dart';
import '../widgets/hamburger_menu.dart';


class AbsenceView extends StatefulWidget {
  const AbsenceView({Key? key}) : super(key: key);

  @override
  _AbsenceViewState createState() => _AbsenceViewState();
}

class _AbsenceViewState extends State<AbsenceView> {
  final ApiService apiService = ApiService('https://api.isen-cyber.ovh');

  late Future<List<Absence>> _notationsFuture;

  @override
  void initState() {
    super.initState();
    _notationsFuture = apiService.fetchNotations('FAKETOKEN') as Future<List<Absence>>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //white text color
        foregroundColor: Colors.white,
        title: const Text('ENT ISEN Toulon'),
        backgroundColor: Colors.red,
      ),
      drawer: const HamburgerMenu(),
      body: Center(
        child: FutureBuilder<List<Absence>>(
          future: _notationsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Absence absence = snapshot.data![index];
                  return ListTile(
                    title: Text('Date: ${absence.Date}'),
                    subtitle: Text('Course: ${absence.Course}\nHeures: ${absence.Hours}'),
                    trailing: Icon(Icons.arrow_forward),
                    // Add more details if needed
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
