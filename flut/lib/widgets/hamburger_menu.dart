import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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