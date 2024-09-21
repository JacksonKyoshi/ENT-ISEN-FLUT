import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

import '../../model/absences.dart';
import '../../services/api_service.dart';
import '../../services/token_service.dart';
import 'absence_list.dart';
import '../../services/cache.dart';

class AbsenceView extends StatefulWidget {
  const AbsenceView({Key? key}) : super(key: key);

  @override
  _AbsenceViewState createState() => _AbsenceViewState();
}

class _AbsenceViewState extends State<AbsenceView> {
  final ApiService apiService = ApiService('https://api-ent.isenengineering.fr');
  final String token = TokenManager.getInstance().getToken();

  final String cacheFileName = "absence.cache";

  late Future<List<Absence>> _absenceFuture;

  @override
  void initState() {
    super.initState();
    _absenceFuture = _loadAbsences(false);
    _updateCache();
  }

  void _updateCache() async {
    List<Absence> absences = await apiService.fetchAbsence(token);

    String jsonString = jsonEncode(absences.map((e) => e.toJson()).toList());
    await writeToCache('absences.cache', jsonString);
  }

  Future<List<Absence>> _retrieveDataFromCache() async {
    String? cacheValue = await readFromCache(cacheFileName);

    if (cacheValue == null) {
      throw PathNotFoundException;
    }

    List<dynamic> absenceJson = json.decode(cacheValue);
    List<Absence> cachedAbsences = absenceJson.map((json) => Absence.fromJson(json)).toList();
    return cachedAbsences;
  }

  Future<List<Absence>> _loadAbsences(bool forceRefresh) {
    if (!forceRefresh) {
      return _absenceFuture = _retrieveDataFromCache().
      catchError((err) {
        if (err.toString().contains("PathNotFoundException")) {
          return _loadAbsences(true);
        }
        throw err;
      });
    }
    return _absenceFuture = apiService.fetchAbsence(token);
  }

  Future<void> _onRefresh() {
    setState(() {
      _loadAbsences(true);
    });

    return _absenceFuture;
  }

  List<double> _countAbsencesHours(List<Absence> absences) {
    List<double> counter = [0.0, 0.0, 0.0, 0.0];

    for (Absence absence in absences) {
      List<String> parsedDuration = absence.duration.split(":");
      double durationHours = double.parse(parsedDuration[0]);
      double durationMinutes = double.parse(parsedDuration[1]);
      double duration = durationHours + durationMinutes / 60.0;

      counter[0] += duration;

      switch (absence.reason) {
        case "Absence justifiée":
          counter[1] += duration;
          break;
        case "Absence excusée":
          counter[2] += duration;
          break;
        case "Absence non excusée":
          counter[3] += duration;
          break;
      }
    }

    return counter;
  }

  String _formatDuration(double hours) {
    int hoursPart = hours.floor();
    int minutesPart = ((hours - hoursPart) * 60).round();
    return "${hoursPart}h${minutesPart.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<List<Absence>>(
          future: _absenceFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return LayoutBuilder(
                builder: (context, constraints) => RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: constraints.maxWidth,
                        minHeight: constraints.maxHeight,
                      ),
                      child: Center(child: Text('Error: ${snapshot.error}')),
                    ),
                  ),
                ),
              );
            } else {
              List<Absence> absences = snapshot.data!;
              List<double> absencesHours = _countAbsencesHours(absences);

              return Column(
                children: [
                  Card(
                    child: ExpansionTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            _formatDuration(absencesHours[0]),
                            style: const TextStyle(color: Colors.red, fontSize: 32),
                          ),
                          const Text(" d'absences", style: TextStyle(fontSize: 20)),
                        ],
                      ),
                      children: [
                        _buildAbsenceRow(
                          _formatDuration(absencesHours[1]),
                          " d'absences justifiées",
                          Colors.green,
                        ),
                        _buildAbsenceRow(
                          _formatDuration(absencesHours[2]),
                          " d'absences excusées",
                          Colors.lightGreen,
                        ),
                        _buildAbsenceRow(
                          _formatDuration(absencesHours[3]),
                          " d'absences non excusées",
                          Colors.red,
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: AbsenceList(absences: absences, onRefresh: _onRefresh,)),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildAbsenceRow(String duration, String label, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          duration,
          style: TextStyle(color: color, fontSize: 20),
        ),
        Text(label, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
