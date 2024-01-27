import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
              Navigator.pop(context);
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
              Navigator.pop(context);
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
              Navigator.pop(context);
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
              Navigator.pop(context);
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
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}