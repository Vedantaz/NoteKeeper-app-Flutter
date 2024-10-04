import 'package:flutter/material.dart';
import 'package:notekeeper_app/screens/note_details.dart';
// import 'package:flutter/services.dart';
// import 'package:notekeeper_app/main.dart';

class NoteList extends StatefulWidget {
  const NoteList({super.key});

  @override
  State<StatefulWidget> createState() => NoteListState();
}

class NoteListState extends State<NoteList> {
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
          navigateToDetail('Add Note');
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
            leading: const CircleAvatar(
              backgroundColor: Colors.yellow,
              child: Icon(Icons.keyboard_arrow_right),
            ),
            title: const Text(
              'Dummy title',
              style: TextStyle(
                  color: Colors.black), // Changed color for visibility
            ),
            subtitle: const Text('Dummy date'),
            trailing: const Icon(
              Icons.delete,
              color: Colors.blueGrey,
            ),
            onTap: () {
              debugPrint('print the statement');
              navigateToDetail('Edit Note');
            },
          ),
        );
      },
    );
  }

  void navigateToDetail(String title) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(
        appTitle: title,
      );
    }));
  }
}
