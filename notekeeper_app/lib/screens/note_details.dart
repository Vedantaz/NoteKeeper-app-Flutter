import 'package:flutter/material.dart';


class NoteDetail extends StatefulWidget {
  @override
  final String appTitle;
  const NoteDetail({super.key, required this.appTitle});

  @override
  State<StatefulWidget> createState() => NoteDetailState(appTitle);
}

class NoteDetailState extends State<NoteDetail> {
  static final _priorities = ['High', 'Low'];
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  NoteDetailState(this.appTitle);

  String appTitle;
  String _selectedPriority = 'Low';
  int count = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
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
    Navigator.pop(context);
    return true;
  }
}
