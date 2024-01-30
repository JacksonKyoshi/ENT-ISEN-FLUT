// services/api_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/notation.dart';


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
      print(response.body);
      print(response.body.toString());
      List<Notation> notations = notationsJson
          .map((json) => Notation.fromJson(json))
          .toList();

      return notations;
    } else {
      throw Exception('Failed to load notations');
    }
  }

  // Add absence fetching

}
