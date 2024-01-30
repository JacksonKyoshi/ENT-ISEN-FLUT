import 'package:flutter/material.dart';

import '../model/notation.dart';
import '../services/api_service.dart';
import '../services/token_service.dart';
import '../widgets/hamburger_menu.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  _NotesScreenState createState() => _NotesScreenState();
}
class _NotesScreenState extends State<NotesScreen> {
  final ApiService apiService = ApiService('https://api.isen-cyber.ovh');

  late Future<List<Notation>> _notationsFuture;

  @override
  void initState() {
    super.initState();
    String token = TokenManager.getInstance().getToken();
    _notationsFuture = apiService.fetchNotations(token) as Future<List<Notation>>;

    print('token : fils de pute de merde pourquoi tu marches aps enculé $token');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text('ENT ISEN Toulon'),
        backgroundColor: Colors.red,
      ),
      drawer: const HamburgerMenu(),
      body: Center(
        child: FutureBuilder<List<Notation>>(
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
                  Notation notation = snapshot.data![index];
                  return ListTile(
                    title: Text('Date: ${notation.date}'),
                    subtitle: Text('Code: ${notation.code}\nNote: ${notation.note}'),
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
