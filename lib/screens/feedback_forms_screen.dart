import 'package:flutter/material.dart';

enum FeedbackFormOption{
  BUG,
  FEATURE
}

class FeedbackFormsScreen extends StatelessWidget {
  final FeedbackFormOption formOption;

  const FeedbackFormsScreen({super.key, required this.formOption});

  @override
  Widget build(BuildContext context) {
    switch(formOption) {
      case FeedbackFormOption.BUG:
        return Scaffold(
          appBar: AppBar(
            title: const Text('Rapport de bug'),
          ),
          body: const Center(child: Text("Coming soon"))
        );
      case FeedbackFormOption.FEATURE:
        return Scaffold(
          appBar: AppBar(
            title: const Text('Demande de fonctionnalité'),
          ),
          body: const Center(child: Text("Coming soon"))
        );
    }
  }

}