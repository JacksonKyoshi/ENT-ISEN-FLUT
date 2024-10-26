
import 'package:flut/model/notation.dart';
import 'package:flutter/material.dart';

class NotesCaroussel extends StatelessWidget {
  final List<Notation> notes;

  const NotesCaroussel({super.key, required this.notes});

  //only keep the 5 most recent notes to display
  List<Notation> getRecentNotes() {
    //sort notes by date
    List<Notation> sortedNotes = List.from(notes);
    sortedNotes.sort((a, b) => a.date.compareTo(b.date));
    //reverse the list to have the most recent notes first
    sortedNotes = sortedNotes.reversed.toList();
    //keep only the 5 most recent notes
    if (sortedNotes.length > 5) {
      sortedNotes = sortedNotes.sublist(0, 5);
    }
    return sortedNotes;
  }

  @override
  Widget build(BuildContext context) {
    List<Notation> recentNotes = getRecentNotes();
    if (recentNotes.isEmpty) {
      return Center(
        child: Text(
          'No notes available',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      );
    }
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height / 5,
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: getRecentNotes().length,
        itemBuilder: (context, index) {
          Notation note = getRecentNotes()[index];
          return Container(
            width: MediaQuery.of(context).size.width / 1.5,
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    note.date,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    note.name,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      note.note,
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}