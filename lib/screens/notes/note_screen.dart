import 'dart:convert';
import 'dart:io';

import 'package:ent/widgets/custom_card_list.dart';
import 'package:flutter/material.dart';
import '../../model/notation.dart';
import '../../services/api_service.dart';
import '../../services/cache.dart';
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
  final String token = TokenManager.getInstance().getToken();

  late Future<List<Notation>> _notationsFuture;

  final String cacheFileName = "notations.cache";

  @override
  void initState() {
    super.initState();

    _notationsFuture = apiService.fetchNotations(token);
  }

  void _updateCache() async {
    List<Notation> notations = await apiService.fetchNotations(token);

    String jsonString = jsonEncode(notations.map((e) => e.toJSON()).toList());
    await writeToCache(cacheFileName, jsonString);
  }

  Future<List<Notation>> _retrieveDataFromCache() async {
    String? cacheValue = await readFromCache(cacheFileName);

    if (cacheValue == null) {
      throw PathNotFoundException;
    }

    List<dynamic> absenceJson = json.decode(cacheValue);
    List<Notation> cachedNotations = absenceJson.map((json) => Notation.fromJson(json)).toList();
    return cachedNotations;
  }

  Future<List<Notation>> _loadNotations(bool forceRefresh) {
    if (!forceRefresh) {
      return _notationsFuture = _retrieveDataFromCache().
      catchError((err) {
        if (err.toString().contains("PathNotFoundException")) {
          return _loadNotations(true);
        }
        throw err;
      });
    }
    return _notationsFuture = apiService.fetchNotations(token);
  }

  Future<void> _onRefresh() {
    setState(() {
      _loadNotations(true);
    });

    return _notationsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Notation>>(
        future: _notationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
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
            if (snapshot.data!.isEmpty) {
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
                      child: Center(child: Text("Aucune note trouvée", style: Theme.of(context).textTheme.titleLarge)),
                    ),
                  ),
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
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
              )
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
