import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:notekeeper_app/models/notes.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance =
      DatabaseHelper._internal(); // singleton databaseHelper
  factory DatabaseHelper() => _instance;
  static Database? _database; // singleton database
  DatabaseHelper._internal();

  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDesc = 'description';
  String colPriority = 'priority';
  String colDate = 'date';

  DatabaseHelper._createInstance();

  // factory DatabaseHelper() {
  //   return _instance;
  // }

  Future<Database> get database async {
    _database ??= await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'notes.db');

    //open/create a database at a given path

    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int newVersion) async {
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
    var db = await database;
    var res = await db.update(noteTable, note.toMap(),
        where: '$colId = ?', whereArgs: [note.id]);
    return res;
  }

  // Delete operation - Delete a note object from database
  Future<int> deleteNote(int id) async {
    var db = await database;
    var res =
        await db.rawDelete('DELETE FROM $noteTable WHERE $colId = ?', [id]);
    return res;
  }

  // Get number of note objects in database
  Future<int> getCount(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) FROM $noteTable');
    int? res = Sqflite.firstIntValue(x);
    return res ?? 0; // Return 0 if res is null
  }

  // get the map list List<Map> from database / function and convert it to 'note_list List<Notes>

  Future<List<Notes>> getNoteList() async {
    var noteMapList = await getNoteListMap();
    int count = noteMapList.length;
    List<Notes> noteList = []; // Creates an empty list

    // For loop to convert each mapList into its respective object
    for (int i = 0; i < count; i++) {
      noteList.add(Notes.fromMapObject(noteMapList[i]));
    }
    return noteList;
  }
}
