import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flut - ENT ISEN'),
      ),
      body: Center(
        child: Text("Coming soon", style: Theme.of(context).textTheme.titleLarge)
      )
    );
  }
  
}