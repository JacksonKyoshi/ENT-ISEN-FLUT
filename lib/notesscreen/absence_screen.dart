import 'package:flutter/material.dart';

import '../model/absences.dart';
import '../services/api_service.dart';
import '../services/token_service.dart';
import '../widgets/hamburger_menu.dart';


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
      appBar: AppBar(
        //white text color
        foregroundColor: Colors.white,
        title: const Text('ENT ISEN Toulon'),
        backgroundColor: Colors.red,
      ),
      drawer: const HamburgerMenu(),
      body: Center(
        child: FutureBuilder<List<Absence>>(
          future: _absenceFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('Aucune absences', style: TextStyle(fontSize: 20)),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Absence absence = snapshot.data![index];
                    return ListTile(
                      title: Text('Date: ${absence.date}'),
                      subtitle: Text('Course: ${absence.subject}\nHeures: ${absence.hours}\n${absence.reason}'),
                      trailing: const Icon(Icons.arrow_forward),
                    );
                  },
                );
              }
            }
          },
        ),
      ),
    );
  }
}
