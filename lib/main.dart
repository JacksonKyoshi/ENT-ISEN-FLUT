import 'package:ent/main_handler.dart';
import 'package:ent/services/token_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'services/calendar_service.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';


void main() {
  initializeDateFormatting('fr_FR', "").then((_) => runApp(LoginApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CalendarEventProvider(),
      child: MaterialApp(
        title: 'ENT ISEN Toulon',
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate
        ],
        supportedLocales: const [
          Locale("fr")
        ],
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
          primarySwatch: Colors.purple,
          splashColor: const Color(0x00000000),
          appBarTheme: const AppBarTheme(
            foregroundColor: Color(0xFFFFFFFF),
            backgroundColor: Color(0xFF2A2450),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color(0xFF2A2450),
            selectedLabelStyle: TextStyle(
              fontSize: 14,
            ),
            selectedItemColor: Color(0xFFFFFFFF),
            selectedIconTheme: IconThemeData(
                size: 32
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 14,
            ),
            unselectedItemColor: Color(0xFF888888),
            unselectedIconTheme: IconThemeData(
                size: 24
            ),
            showUnselectedLabels: true,
          )

        ),
        home: MainHandler(),
      ),
    );
  }

}