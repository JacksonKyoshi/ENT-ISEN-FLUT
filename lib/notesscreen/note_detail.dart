import 'package:flutter/material.dart';
import '../model/notation_class.dart';
import '../services/api_service.dart';
import '../services/token_service.dart';

class NoteDetail extends StatelessWidget {
  final String code;

  NoteDetail({required this.code});

  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService('https://api-ent.isenengineering.fr');

    return FutureBuilder<NotationClass>(
      future: _fetchNotationClass(code, apiService),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return AlertDialog(
            title: Text('Loading...'),
            content: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to load notation data: ${snapshot.error}'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        } else if (snapshot.hasData) {
          NotationClass notation = snapshot.data!;
          return AlertDialog(
            title: Text('Informations'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Matière: ${notation.code}'),
                Text('Note personnelle: ${notation.notePersonal}'),
                Text('Moyenne de classe: ${notation.noteAverage}'),
                Text('Note minimale: ${notation.noteMin}'),
                Text('Note maximale: ${notation.noteMax}'),
                Text("Nombre d'étudiants: ${notation.presence}"),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        } else {
          return AlertDialog(
            title: Text('No Data'),
            content: Text('No data available for the selected notation.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
      },
    );
  }

  Future<NotationClass> _fetchNotationClass(String code, ApiService apiService) async {
    String token = TokenManager.getInstance().getToken();
    List<NotationClass> notations = await apiService.fetchNotationsClass(token);
    return notations.firstWhere((notation) => notation.name == code);
  }
}
