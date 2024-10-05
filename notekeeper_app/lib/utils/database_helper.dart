import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:notekeeper_app/models/notes.dart';

class DatabaseHelper {
  static DatabaseHelper databaseHelper; // singleton databaseHelper
  static Database _database; // singleton database

  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDesc = 'description';
  String colPriority = 'priority';
  String colDate = 'date';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    databaseHelper ??= DatabaseHelper._createInstance();
    return databaseHelper;
  }

  Future<Database> get database async {
    return database;
  }

  Future<Database> intializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();

    String path = '${directory.path}notes db';

    //open/create a database at a given path

    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT , $colTitle TEXT, $colDesc TEXT, $colPriority INTEGER, $colDate TEXT)');
  }

  // fetch operation oif getting all objects from database
  Future<List<Map<String, dynamic>>> getNoteListMap() async {
    Database db = await database;
    var res =
        await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    // var result = await db.query(noteTable, orderBy: '$colPriority ASC' );

    return res;
  }

  // insert operation - Insert a note object to the database
  Future<int> insertNote(Notes note) async {
    Database db = await database;
    var res = await db.insert(noteTable, note.toMap());
    return res;
  }

  // Update operation - Insert a note object and save it to the database
  Future<int> updateNote(Notes note) async {
    Database db = await database;
    var res = await db.insert(noteTable, note.toMap(),
        where: '$colId = ?', whereArgs: [note.id]);
    return res;
  }

  // Delete operation - Delete a note object from database
  Future<int> deleteNote(int id) async {
    Database db = await database;
    var res = await db.rawDelete('DELETE FROM $noteTable WHERE $colId = id');
    return res;
  }

  // Get number of note objects in database
  Future<int> getCount(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT FROM $noteTable');
    int res = Sqflite.firstIntValue(x);
    return res;
  }

  // get the map list List<Map> from database / function and convert it to 'note_list List<Notes>

  Future<List<Notes>> getNoteList() async {
    var noteMapList = await getNoteMapList();
    int count = noteMapList.length;
    List<Notes> noteList = List<Notes>();
    // For loop to convert each mapList into its respective object
    for (int i = 0; i < count; i++) {
      noteList.add(Notes.fromMapObject(noteMapList[i]));
    }
    return noteList;
  }
}
