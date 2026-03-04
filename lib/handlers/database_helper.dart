import 'dart:io';
import 'package:jnjversion01windows/models/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _dbName = "userDatabase.db";
  static final _dbVersion = 1;
  //making a singleton class
  DatabaseHelper._privateContsructor();
  //constructor
  static final DatabaseHelper instance = DatabaseHelper._privateContsructor();

  //initialize database
  static Database? _database;
  //if the datbase variable does not exist then we need to initialize database first
  Future<Database> get database async => _database ??= await _initiateDatabase();

  _initiateDatabase () async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate,);
  }

  Future _onCreate(Database db, int version) async{

    await db.execute('''
          CREATE TABLE tbl_users (
            id INTEGER PRIMARY KEY,
            mid TEXT,
            name TEXT,
            surname TEXT,
            cell TEXT,
            email TEXT,
            profile_url TEXT,
            accessToken TEXT,
            token TEXT
          )
        '''
    );
  }

  Future<User> getUser() async {

    Database db = await instance.database;
    var myUser = await db.query('tbl_users', orderBy: 'name');

    User userIte = myUser.isNotEmpty ?
    User.fromMap(myUser.first) :
    User(
        mid: "",
        name: "",
        surname: "",
        cell: "",
        email: "",
        profile_url: "",
        token: '',
        accessToken: '');
    return userIte;
  }

  Future<int> add(User user) async {
    Database db = await instance.database;
    return await db.insert('tbl_users', user.toMap());
  }

  Future<int> update(User user) async {
    Database db = await instance.database;
    return await db.update('tbl_users', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  Future<int> removeLogout(int id) async{
    Database db = await instance.database;
    return await db.delete('tbl_users', where: 'id = ?', whereArgs: [id]);
  }
}