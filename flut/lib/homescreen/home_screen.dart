// screens/home_screen.dart
import 'package:flutter/material.dart';


import '../model/notation.dart';
import '../notesscreen/note_screen.dart';
import '../services/api_service.dart';
import '../services/token_service.dart';
import '../widgets/hamburger_menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService('https://api.isen-cyber.ovh');

  late Future<List<Notation>> _notationsFuture;

  @override
  @override
  void initState() {
    super.initState();
    String token = TokenManager.getInstance().getToken();
    print('token de fou : $token');
    _notationsFuture = apiService.fetchNotations(token);

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
        child: Container(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: const Text('Latest notes :', style: TextStyle(fontSize: 20)),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotesScreen()),
                  );
                },
                child: FutureBuilder<List<Notation>>(
                  future: _notationsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        width: MediaQuery.of(context).size.width -30,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.blue.shade100,
                        ),
                        child: Column(
                          children: [
                            Text(snapshot.data![0].code),
                            Text(snapshot.data![0].note, style: const TextStyle(fontSize: 30)),
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                      return const CircularProgressIndicator();
                    },
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
