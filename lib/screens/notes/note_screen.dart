import 'package:ent/widgets/custom_card_list.dart';
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
    _notationsFuture = apiService.fetchNotations(token);
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
            if (snapshot.data!.isEmpty) {
              return Center(child: Text("Aucune note trouvée", style: Theme.of(context).textTheme.titleLarge));
            }
            return ListView.builder(
              padding: EdgeInsets.all(8.0),
              shrinkWrap: true, // Réduit la taille de ListView à son contenu
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Notation notation = snapshot.data![index];

                return CustomCardList(
                    onTap: () => _showEditDialog(context, notation.code),
                    constraints: BoxConstraints(maxHeight: 100),
                    leadingColor: Colors.purple,
                    leading: Text(
                      notation.date,
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    title: AutoSizeText(
                      notation.name,
                      style: TextStyle(fontSize: 20.0,fontWeight:FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    subtitle: Text(
                      notation.comments,
                      style: TextStyle(
                          fontSize: 14.0, color: Colors.grey[700]),
                    ),
                    trailing: Text(
                      notation.note,
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                    )
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
