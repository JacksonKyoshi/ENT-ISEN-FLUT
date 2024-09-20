import 'package:flut/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/calendar_screen.dart';
import '../screens/absences/absence_screen.dart';
import '../screens/notes/note_screen.dart';

class HamburgerMenu extends StatelessWidget {
  const HamburgerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            height: 200, // specify the height
            width: 300, // specify the width
            child: DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.red,
              ),
              child: Column(
                children: [
                  const Text(
                    'ENT ISEN Toulon',
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
          ),
          ListTile(
            leading: SvgPicture.asset(
              'lib/assets/SVG/house-solid.svg',
              height: 24,
              width: 24,
              color: Colors.black,
            ),
            title: const Text('Accueil'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
          ),
          ListTile(
            leading: SvgPicture.asset(
              'lib/assets/SVG/graduation-cap-solid.svg',
              height: 24,
              width: 24,
              color: Colors.black,
            ),
            title: const Text('Notes'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotesScreen()),
              );
            },
          ),
          ListTile(
            leading: SvgPicture.asset(
              'lib/assets/SVG/calendar-days-solid.svg',
              height: 24,
              width: 24,
              color: Colors.black,
            ),
            title: const Text('Emploi du temps'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CalendarScreen()),
              );
            },
          ),
          ListTile(
            leading: SvgPicture.asset(
              'lib/assets/SVG/user-large-slash-solid.svg',
              height: 24,
              width: 24,
              color: Colors.black,
            ),
            title: const Text('Absences'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AbsenceView()),
              );
            },
          ),
          ListTile(
            leading: SvgPicture.asset(
              'lib/assets/SVG/book-solid.svg',
              height: 24,
              width: 24,
              color: Colors.black,
            ),
            title: const Text('EDUC'),
            onTap: () {
              launch('https://educ.isen-mediterranee.fr/fr/');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: SvgPicture.asset(
              'lib/assets/SVG/globe-solid.svg',
              height: 24,
              width: 24,
              color: Colors.black,
            ),
            title: const Text('Site web'),
            onTap: () {
              launch('https://www.isen-mediterranee.fr/');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}