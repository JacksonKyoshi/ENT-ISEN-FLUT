import 'package:flutter/material.dart';
import '../../model/notation_class.dart';
import '../../services/api_service.dart';
import '../../services/token_service.dart';

class NoteDetail extends StatelessWidget {
  final String code;

  NoteDetail({required this.code});

  @override
  Widget build(BuildContext context) {
    final ApiService apiService =
        ApiService('https://api-ent.isenengineering.fr');

    return FutureBuilder<NotationClass>(
      future: _fetchNotationClass(code, apiService),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Failed to load notation data: ${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          // Une fois les données récupérées, afficher la feuille modale
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showNotationModal(context, snapshot.data!).then((_) {
              Navigator.pop(
                  context); // Fermer la page une fois la modale fermée
            });
          });

          return SizedBox
              .shrink(); // N'affiche rien pendant que la feuille modale est affichée
        } else {
          return Center(
            child: Text('No data available for the selected notation.'),
          );
        }
      },
    );
  }

  Future<NotationClass> _fetchNotationClass(
      String code, ApiService apiService) async {
    String token = TokenManager.getInstance().getToken();
    List<NotationClass> notations = await apiService.fetchNotationsClass(token);
    return notations.firstWhere((notation) => notation.name == code);
  }

  // Modification pour gérer la fermeture correcte de la modale
  Future<void> _showNotationModal(
      BuildContext context, NotationClass notation) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Container(
                  height: 5,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 100,
                child: Text(
                  notation.code,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.school),
                          SizedBox(width: 8),
                          Text(
                            'Note élève :',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        notation.notePersonal,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              buildRowWithIcon(Icons.assessment, 'Moyenne classe :', notation.noteAverage),
              buildRowWithIcon(Icons.trending_up, 'Note maximale :', notation.noteMax),
              buildRowWithIcon(Icons.trending_down, 'Note minimale :', notation.noteMin),
              buildRowWithIcon(Icons.people, "Nombre d'étudiant :", notation.presence),

              ],
          )
        );
      },
    );
  }
}

Widget buildRowWithIcon(IconData icon, String text, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          Icon(icon, color: Colors.black),
          SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
      Text(
        value,
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    ],
  );
}

