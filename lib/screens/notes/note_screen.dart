import 'package:flutter/material.dart';
import '../../model/notation.dart';
import '../../services/api_service.dart';
import '../../services/token_service.dart';
import '../../widgets/hamburger_menu.dart';
import 'note_detail.dart'; // Importer la nouvelle classe
import 'package:auto_size_text/auto_size_text.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final ApiService apiService = ApiService('https://api-ent.isenengineering.fr');

  late Future<List<Notation>> _notationsFuture;

  @override
  void initState() {
    super.initState();
    String token = TokenManager.getInstance().getToken();
    _notationsFuture = apiService.fetchNotations(token) as Future<List<Notation>>;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: FutureBuilder<List<Notation>>(
        future: _notationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              padding: EdgeInsets.all(8.0),
              shrinkWrap: true, // Réduit la taille de ListView à son contenu
              physics: NeverScrollableScrollPhysics(), // Désactive le défilement interne si ce n'est pas nécessaire
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Notation notation = snapshot.data![index];
                return GestureDetector(
                  onTap: () => _showEditDialog(context, notation.code),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded( // Ajout de Expanded pour ajuster dynamiquement la largeur
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 12.0),
                                        decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Text(
                                    notation.date,
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                                SizedBox(width: 12.0),
                                Expanded( // Ajout de Expanded pour ajuster dynamiquement la largeur
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AutoSizeText(
                                        notation.name,

                                        style: TextStyle(fontSize: 20.0,fontWeight:FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      Text(
                                        '${notation.comments}',
                                        style: TextStyle(
                                            fontSize: 14.0, color: Colors.grey[700]),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            notation.note,
                            style: TextStyle(
                                fontSize: 24.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context, String code) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NoteDetail(code: code);
      },
    );
  }
}
