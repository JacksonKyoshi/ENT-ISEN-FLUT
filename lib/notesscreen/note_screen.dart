import 'package:flutter/material.dart';
import '../model/notation.dart';
import '../services/api_service.dart';
import '../services/token_service.dart';
import '../widgets/hamburger_menu.dart';
import 'note_detail.dart'; // Importer la nouvelle classe

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final ApiService apiService = ApiService('https://api-ent.isenengineering.fr');

  late Future<List<Notation>> _notationsFuture;

  @override
  void initState() {
    super.initState();
    String token = TokenManager.getInstance().getToken();
    _notationsFuture = apiService.fetchNotations(token) as Future<List<Notation>>;
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
                    title: Text('Code: ${notation.code}'),
                    subtitle: Text('Date: ${notation.date}\nNote: ${notation.note}'),
                    onTap: () => _showEditDialog(context, notation.code),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, String code) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NoteDetail(code: code);
      },
    );
  }
}
