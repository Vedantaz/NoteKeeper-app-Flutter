import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notekeeper_app/models/notes.dart';
import 'package:notekeeper_app/utils/database_helper.dart';
// import 'package:sqflite/sqflite.dart';

class NoteDetail extends StatefulWidget {
  // @override
  final String appTitle;
  final Notes note;

  const NoteDetail({super.key, required this.appTitle, required this.note});

  @override
  State<StatefulWidget> createState() =>
      NoteDetailState(this.note, this.appTitle);
  // NoteDetailState();
}

class NoteDetailState extends State<NoteDetail> {
  static final _priorities = ['High', 'Low'];
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  NoteDetailState(this.note, this.appTitle);
  Notes note;
  String appTitle;

  String _selectedPriority = 'Low';
  DatabaseHelper helper = DatabaseHelper();

  int count = 0;

  @override
  void initState() {
    super.initState();
    // note = widget.note; // Initialize the note
    // appTitle = widget.appTitle; // Initialize the app title

    titleController.text = widget.note.title; // Use widget to access note
    descController.text = widget.note.desc;
  }

  @override
  Widget build(BuildContext context) {
    // titleController.text = note.title;
    // descController.text = note.desc;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.appTitle),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context), // Simplified navigation
          ),
        ),
        body: WillPopScope(
          onWillPop: () async {
            return true;
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                ListTile(
                  title: DropdownButton(
                      items: _priorities.map((String dropDownStringItem) {
                        return DropdownMenuItem<String>(
                          value: dropDownStringItem,
                          child: Text(dropDownStringItem),
                        );
                      }).toList(),
                      value: _selectedPriority,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedPriority = newValue!;
                          debugPrint('User Selected $_selectedPriority');
                          updatePriorityInt(_selectedPriority);
                        });
                      }),
                ),

                // second element = textField
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: titleController,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold),
                    onChanged: (value) {
                      debugPrint('Something changed in Title txt field');
                      updateTitle();
                    },
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                // third element =

                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: descController,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold),
                    onChanged: (value) {
                      debugPrint('Something changed in Description txt field');
                      updateDesc();
                    },
                    decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),

                // fourth element ->> a row

                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context)
                                .primaryColorDark, // Background color
                            foregroundColor: Theme.of(context)
                                .primaryColorLight, // Text color
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(fontSize: 14),
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint('Save button clicked');
                              save();
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context)
                                .primaryColorDark, // Background color
                            foregroundColor: Theme.of(context)
                                .primaryColorLight, // Text color
                          ),
                          child: const Text(
                            'delete',
                            style: TextStyle(fontSize: 14),
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint('Delete button clicked');
                              delete();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
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
            },
          ),
        );
      },
    );
  }

  bool moveToLastScreen() {
    if (mounted) {
      Navigator.pop(context, true);
    }
    // Navigator.pop(context, true);
    return true;
  }

  // convert the string priority to the form of integer value before saving it to the database;
  void updatePriorityInt(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }

  // convert the int priority to the form of string value and display it to the user in dropdown;
  String getPriorityAsString(String value) {
    String priority = '';
    switch (value) {
      case '1':
        priority = _priorities[0];
        break;
      case ' 2':
        priority = _priorities[1];
        break;
    }
    return priority;
  }

  // update the title of note objects
  void updateTitle() {
    note.title = titleController.text;
  }

  void updateDesc() {
    note.desc = descController.text; // desc is a textfield
  }

  void save() async {
    moveToLastScreen();

    note.date = DateFormat.yMMMd().format(DateTime.now());

    int res =
        await helper.updateNote(note); // If you're sure `id` is always present

    // if (note.id != null) {
    //   // case 1 update operation
    //   res = await helper.updateNote(note);
    // } else {
    //   // case 2 insert operation
    //   res = await helper.insertNote(note);
    // }

    if (res != 0) {
      showAlterDialog('Status', 'Note saved successfully.');
    } else {
      showAlterDialog('Status', 'Note saved successfully.');
    }
  }

  void showAlterDialog(String title, String msg) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(msg),
    );

    showDialog(
      context: context,
      builder: (_) => alertDialog,
    );
  }

  void delete() async {
    moveToLastScreen();

    // case 1: if user is trying to delete to New note he haas come tot the details page by pressing the FAB of noteList page

    // if (note.id == null) {
    //   showAlterDialog('Status', 'No note was deleted');
    //   return;
    // }

    int res = await helper.deleteNote(note.id);
    if (res != 0) {
      showAlterDialog('Status', 'Note deleted successfully.');
    } else {
      showAlterDialog('Status', 'Error occured while deleting note');
    }

    // case 2: user is trying to delete the existing note
    helper.deleteNote(note.id);
    Navigator.pop(context);
  }
}
