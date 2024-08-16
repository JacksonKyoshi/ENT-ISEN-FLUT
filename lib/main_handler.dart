import 'package:ent/calendar_screen/calendar_screen.dart';
import 'package:ent/homescreen/home_screen.dart';
import 'package:ent/notesscreen/absence_screen.dart';
import 'package:ent/notesscreen/note_screen.dart';
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
          _pageController.animateToPage(_selectedPage, duration: const Duration(milliseconds: 300), curve: Curves.bounceOut);
        }
    });
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
        body: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          children: _screensList,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF2A2450),
          selectedFontSize: 14,
          selectedItemColor: const Color(0xFFFFFFFF),
          selectedIconTheme: const IconThemeData(
              size: 32,
              color: Color(0xFFFFFFFF)
          ),
          unselectedFontSize: 10,
          unselectedItemColor: const Color(0xFF888888),
          unselectedIconTheme: const IconThemeData(
              size: 24,
              color: Color(0xFF888888)
          ),
          showUnselectedLabels: true,
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
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.menu),
                label: "Autre"
            ),

          ],

          currentIndex: _selectedPage,
          onTap: _onItemTap,
        )
    );
  }
}
