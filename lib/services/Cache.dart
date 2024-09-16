import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../main.dart';
import '../services/User_service.dart';
import '../services/token_service.dart';

Future<void> writeToCache(String fileName, String content) async {
  try {
    // Obtenir le répertoire temporaire (cache)
    Directory tempDir = await getTemporaryDirectory();

    // Construire le chemin du fichier dans le répertoire de cache
    String filePath = '${tempDir.path}/$fileName';

    // Créer le fichier et écrire les données
    File file = File(filePath);
    await file.writeAsString(content);

    print('Fichier écrit dans le cache à: $filePath');
  } catch (e) {
    print('Erreur lors de l\'écriture dans le cache: $e');
  }
}

Future<String?> readFromCache(String fileName) async {
  try {
    // Obtenir le répertoire temporaire (cache)
    Directory tempDir = await getTemporaryDirectory();

    // Construire le chemin du fichier dans le répertoire de cache
    String filePath = '${tempDir.path}/$fileName';

    // Vérifier si le fichier existe
    File file = File(filePath);
    if (await file.exists()) {
      // Lire les données du fichier
      String content = await file.readAsString();
      return content;
    } else {
      print('Fichier non trouvé dans le cache.');
      return null;
    }
  } catch (e) {
    print('Erreur lors de la lecture du cache: $e');
    return null;
  }
}
