import 'dart:io';

import 'package:ent/services/cache.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void logout(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Se déconnecter ?"),
            content: Text("Cette fonctionnalité n'est pas encore implémentée."),
            actions: [
              TextButton(
                  child: Text("Ok"),
                  onPressed: () => { Navigator.of(context).pop() },
              )
            ],
          );
        }
    );
  }

  void clearCache(BuildContext context) async {
    void deleteCacheFiles() async {
      final directory = await getApplicationDocumentsDirectory();
      for (FileSystemEntity file in directory.listSync()) {
        if (file.uri.toString().endsWith(".cache")) {
          await file.delete();
        }
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Supprimer le cache ?"),
          content: const Text("Le cache permet à l'application de charger plus rapidement mais contient des données personnelles.\n"
              "Vos informations de login peuvent être supprimées en décochant \"Se souvenir de moi\".\n"
              "Les autres données sauvegardées dans le cache seront à nouveau présentes lors de la prochaine requête, il n'y a actuellement pas d'option pour empêcher cette fonctionnalité.\n"
              "Utilisez le formulaire pour proposer une fonctionnalité pour nous signaler que vous voudriez la fonctionnalité."),
          actions: [
            TextButton(
              child: Text("Non"),
              onPressed: () => { Navigator.of(context).pop() },
            ),
            TextButton(
              child: Text("Oui"),
              onPressed: () { deleteCacheFiles(); Navigator.of(context).pop(); },
          )
          ],
        );
        }
    );
  }

  void reportBug() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Se déconnecter"),
            onTap: () => logout(context),
          ),
          ListTile(
            leading: Icon(Icons.clear),
            title: Text("Supprimer les données du cache"),
            onTap: () => clearCache(context),
          ),
          ListTile(
            leading: Icon(Icons.report),
            title: Text("Rapporter un bug"),
            onTap: reportBug,
          ),
          ListTile(
            leading: Icon(Icons.feedback),
            title: Text("Proposer une fonctionnalité"),
            onTap: reportBug,
          ),

        ],
      )
    );
  }
  
}