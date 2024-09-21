import 'package:ent/screens/calendar_screen.dart';
import 'package:ent/screens/home_screen.dart';
import 'package:ent/screens/absences/absence_screen.dart';
import 'package:ent/screens/notes/note_screen.dart';
import 'package:ent/screens/settings_screen.dart';
import 'package:flutter/material.dart';

class MainHandler extends StatefulWidget {
  const MainHandler({super.key});

  @override
  _MainHandlerState createState() => _MainHandlerState();
}

class _MainHandlerState extends State<MainHandler> {
  final _pageController = PageController();

  int _selectedPage = 0;
  int _previousSelectedPage = 0;
  final List<Widget> _screensList = const <Widget>[
    HomeScreen(),
    CalendarScreen(),
    NotesScreen(),
    AbsenceView()
  ];

  void _onItemTap(int itemIndex) {
    setState(() {
        if (_selectedPage != itemIndex) {
          _previousSelectedPage = _selectedPage;
          _selectedPage = itemIndex;
        }
    });
    _pageController.animateToPage(_selectedPage, duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void _onPageChanged(int itemIndex) {
    setState(() {
      _previousSelectedPage = _selectedPage;
      _selectedPage = itemIndex;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Flut - ENT ISEN'),
          actions: [
            IconButton(
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsScreen())
                  )
                },
                icon: Icon(Icons.settings))
          ],
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          children: _screensList,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Accueil"
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month),
                label: "Planning"
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.grading),
                label: "Notes"
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.do_not_step),
                label: "Absences"
            )
          ],

          currentIndex: _selectedPage,
          onTap: _onItemTap,
        )
    );
  }
}
