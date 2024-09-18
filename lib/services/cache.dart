import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../main.dart';
import '../services/User_service.dart';
import '../services/token_service.dart';

import 'package:path_provider/path_provider.dart';
import 'dart:io';


Future<String> getCacheFilePath(String fileName) async {
  final directory = await getApplicationDocumentsDirectory();  // Répertoire de documents
  final path = '${directory.path}/$fileName';
  return path;
}

// Fonction pour écrire dans le cache
Future<void> writeToCache(String fileName, String data) async {
  try {
    final path = await getCacheFilePath(fileName);
    final file = File(path);
    await file.writeAsString(data);
  } catch (e) {
    debugPrint('Erreur lors de la création du fichier : $e');
  }
}

// Fonction pour lire depuis le cache
Future<String?> readFromCache(String fileName) async {
  try {
    final path = await getCacheFilePath(fileName);
    final file = File(path);
    if (await file.exists()) {
      String contents = await file.readAsString();
      return contents;
    } else {
      return null;
    }
  } catch (e) {
    debugPrint('Erreur lors de la lecture du fichier : $e');
    return null;
  }
}

// Fonction pour supprimer le fichier de cache
Future<void> deleteCacheFile(String fileName) async {
  try {
    final path = await getCacheFilePath(fileName);
    final file = File(path);

    if (await file.exists()) {
      await file.delete();
    }
  } catch (e) {
    debugPrint('Erreur lors de la suppression du fichier : $e');
  }
}
