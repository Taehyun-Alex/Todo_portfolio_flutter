import 'package:sqflite/sqflite.dart';

import '../models/todo.dart';
import '../services/i_datasource.dart';
import 'package:path/path.dart';

class SQLDataSource implements IDataSource {
  late Database _database;
  late Future init;

  static Future<IDataSource> createAsync() async {
    SQLDataSource dataSource = SQLDataSource();
    await dataSource.initialise();
    return dataSource;
  }

  Future initialise() async {

  _database = await openDatabase(
    join(await getDatabasesPath(), 'todo_data.db'),
    version: 1,
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
    // maps[index]['complete'] =
    // (maps[index]['complete'] as int) == 0 ? false : true;
    return Todo.fromMap(maps[index]);
  });
}

@override 
Future<bool> add(Todo model) async {
  Map<String, dynamic> editedMap = model.toMap();
  editedMap.remove('id');
  editedMap['complete'] = editedMap['complete'] as bool ? 1: 0;
    if (await _database.insert('todos', editedMap) == 1){
      return true;
    }else {
      return false;
    }
}

@override
  Future<bool> delete(Todo model) async {
   int result = await _database.delete(
    'todos',
    where: 'id = ?', 
    whereArgs: [model.id]
  );
  if (result > 0) {
    return true;
  } else {
    return false;
  }
  }
  
  @override
  Future<Todo?> read(String id) async {
    List<Map<String, dynamic>> maps = await _database.query(
    'todos',
    where: 'id = ?', 
    whereArgs: [id],
    limit: 1 // Since we're fetching only one task
  );
  if (maps.isNotEmpty) {
    
  } else {
    return null;
  }
  }
  
  @override
  Future<bool> edit(Todo model) async {
    Map<String, dynamic> editedMap = model.toMap();
    int result = await _database.update(
    'todos',
    editedMap,
    where: 'id = ?', 
    whereArgs: [model.id]
  );
  if (result > 0) {
    return true;
  } else {
    return false;
  }

  }

}

