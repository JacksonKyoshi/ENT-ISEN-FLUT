// screens/home_screen.dart
import 'package:flutter/material.dart';

import '../main.dart';
import '../model/notation.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class HamburgerMenu extends StatelessWidget {
  const HamburgerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.red,
            ),
            child: Column(
              children: [
                const Text(
                  'ISEN Toulon',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                Container(
                  child: Image.asset('lib/assets/ISEN-YNCREA-Mediterranee-White.png', fit: BoxFit.cover),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('Accueil'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Actualités'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Agenda'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Annuaire'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Moodle'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Intranet'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Contact'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService('https://api.isen-cyber.ovh');

  late Future<List<Notation>> _notationsFuture;

  @override
  void initState() {
    super.initState();
    _notationsFuture = apiService.fetchNotations('FAKETOKEN') as Future<List<Notation>>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ENT ISEN MOODLE'),

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
