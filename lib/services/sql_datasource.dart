import 'package:sqflite/sqflite.dart';

import '../models/todo.dart';
import '../services/i_datasource.dart';
import 'package:path/path.dart';

class SQLDataSource implements IDatasource {
  late Database _database;

  static Future<IDatasource> createAsync() async {
    SQLDataSource dataSource = SQLDataSource();
    await dataSource.initialise();
    return dataSource;
  }

  Future initialise() async {

  _database = await openDatabase(
    join(await getDatabasesPath(), 'todo_data.db'),
    version: 2,
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE IF NOT EXISTS todos (id INTEGER PRIMARY KEY, name TEXT, description TEXT, complete INTEGER)');
    },
  );
} 

@override 
Future<List<Todo>> browse() async {
  List<Map<String, dynamic>> maps = await _database.query('todos');
  return List.generate(maps.length, (index) {
    maps[index]['complete'] =
    (maps[index]['complete'] as int) == 0 ? false : true;
    return Todo.fromMap(maps[index]);
  });
}

@override 
Future<bool> add(Todo model) async {
  Map<String, dynamic> editedMap = model.toMap();
  editedMap.remove('id');
  if (await _database.insert('todos', editedMap) == 0) {
    return false;
  } else {
    return true;
  }
}

@override 
Future<bool> delete(Todo model) async {
  return false;
}

@override 
Future<Todo?> read(String id) async {
  return null;
}

@override 
Future<bool> edit(Todo model) async {
  return false;
}

}

