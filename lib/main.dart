import 'package:ent/main_handler.dart';
import 'package:ent/services/token_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'services/calendar_service.dart';
import 'homescreen/home_screen.dart';
import 'loginscreen/LoginScreen.dart';


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
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          primarySwatch: Colors.red,
          splashColor: const Color(0x00000000)
        ),
        home: MainHandler(),
      ),
    );
  }

}