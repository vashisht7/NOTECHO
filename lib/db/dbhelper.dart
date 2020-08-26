import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:notecho/db/note.dart';

class DbHelper {
  static final DbHelper _dbHelper = DbHelper._internal();
  String tblNotes = "quotes";
  String colId = "id";
  String colTitle = "title";
  String colDescription = "description";
  String colDate = "date";

  DbHelper._internal();

  factory DbHelper() {
    return _dbHelper;
  }

  static Database _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db;
  }

  Future<Database> initializeDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + "quotes.db";
    
    var dbQuotes = await openDatabase(path, version: 1, onCreate: _createDb); 
    return dbQuotes;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
      "CREATE TABLE $tblNotes($colId INTEGER PRIMARY KEY, $colTitle TEXT, " +
        "$colDescription TEXT,  $colDate TEXT)");
    
  }

  Future<int> insertQuote(Note quote) async {
    Database db = await this.db;
    var result = await db.insert(tblNotes, quote.toMap());
    return result;
  }

  Future<List> getQuotes() async {
    Database db = await this.db;
    var result = await db.rawQuery("SELECT * FROM $tblNotes");
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.db;
    var result = Sqflite.firstIntValue(
      await db.rawQuery("select count (*) from $tblNotes")
    );
    return result;
  }

  Future<int> updateQuote(Note quote) async {
    var db = await this.db;
    var result = await db.update(tblNotes, quote.toMap(),
      where: "$colId = ?", whereArgs: [quote.id]);
    return result;
  }

  Future<int> deleteQuote(int id) async {
    int result;
    var db = await this.db;
    result = await db.rawDelete('DELETE FROM $tblNotes WHERE $colId = $id');
    return result;
  }


}