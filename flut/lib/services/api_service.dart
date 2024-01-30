// services/api_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/notation.dart';
import '../model/absences.dart';


class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<List<Notation>> fetchNotations(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/v1/notations'),
      headers: {'Token': token},
    );

    if (response.statusCode == 200) {
      List<dynamic> notationsJson = json.decode(response.body);

      List<Notation> notations = notationsJson
          .map((json) => Notation.fromJson(json))
          .toList();

      return notations;
    } else {
      throw Exception('Failed to load notations');
    }
  }

  Future<List<Absence>> fetchAbsence(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/v1/absences'),
      headers: {'Token': token},
    );

    if (response.statusCode == 200) {
      List<dynamic> absenceJson = json.decode(response.body);
      List<Absence> absence = absenceJson != null
          ? absenceJson.map((json) => Absence.fromJson(json)).toList()
          : [];
      absence.removeAt(0);
      return absence;
    } else {
      throw Exception('Failed to load absences');
    }
  }

}
