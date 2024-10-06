// import 'dart:io';
import 'dart:async';

import 'package:notekeeper_app/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';

import 'package:notekeeper_app/screens/note_details.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:notekeeper_app/models/notes.dart';

class NoteList extends StatefulWidget {
  const NoteList({super.key});

  @override
  State<StatefulWidget> createState() => NoteListState();
}

class NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Notes> noteList = [];
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColorDark,
        foregroundColor: Theme.of(context).primaryColorLight,
        onPressed: () {
          debugPrint('FAB is clicked');
          navigateToDetail(Notes(), 'Add Note');
        },
        tooltip: 'Add note',
        child: const Icon(Icons.add),
      ),
    );
  }

  ListView getNoteListView() {
    return ListView.builder(
      itemCount: count, // Ensure 'count' is defined somewhere
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.grey,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getPriorityColor(noteList[position].priority),
              child: getPriorityIcon(noteList[position].priority),
            ),
            title: Text(
              noteList[position].title,
              style: const TextStyle(
                  color: Colors.black), // Changed color for visibility
            ),
            subtitle: Text(noteList[position].date),
            trailing: GestureDetector(
              child: const Icon(
                Icons.delete,
                color: Colors.blueGrey,
              ),
              onTap: () {
                delete(context, noteList[position]);
              },
            ),
            onTap: () {
              debugPrint('print the statement');
              navigateToDetail(noteList[position], 'Edit Note');
            },
          ),
        );
      },
    );
  }

  // return the priority color
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.yellow;
      default:
        return Colors.yellow;
    }
  }

  // returns the priority icon
  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return const Icon(Icons.play_arrow);
      case 2:
        return const Icon(Icons.keyboard_arrow_right);
      default:
        return const Icon(Icons.keyboard_arrow_right);
    }
  }

  // returns the priority icon
  void delete(BuildContext context, Notes note) async {
    int res = await databaseHelper.deleteNote(note.id);
    if (res != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String msg) {
    final snackBar = SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Notes note, String title) async {
    bool res =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(
        note: note,
        appTitle: title,
      );
    }));

    if (res == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Notes>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          count = noteList.length;
        });
      });
    });
  }
}
