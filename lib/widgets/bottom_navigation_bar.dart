import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/foundation.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  _CustomBottomNavigationBarState createState() => _CustomBottomNavigationBarState();

}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedItem = 0;

  void _onItemTap(int itemIndex) {
    setState(() {
      debugPrint('Index : $itemIndex');
      _selectedItem = itemIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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

      currentIndex: _selectedItem,
      onTap: _onItemTap,
    );
  }
}
