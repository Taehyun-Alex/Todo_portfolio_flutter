import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
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
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      // Initialize FFI
      sqfliteFfiInit();
      // Use the FFI implementation for the database factory
      databaseFactory = databaseFactoryFfi;
    }

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
    final map = maps[index];
      return Todo.fromMap(map, map['id']);
  });
}

@override 
Future<bool> add(Todo model) async {
  try {
      await _database.insert('todos', model.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Error adding ToDo: $e");
      }
      return false;
    }
}

@override 
Future<bool> delete(Todo model) async {
  try {
      int count = await _database.delete(
        'todos',
        where: 'id = ?',
        whereArgs: [model.id],
      );
      return count > 0;
    } catch (e) {
      if (kDebugMode) {
        print("Error deleting ToDo: $e");
      }
      return false;
    }
}

@override 
Future<Todo?> read(String id) async {
  try {
      List<Map<String, dynamic>> maps = await _database.query(
        'todos',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (maps.isNotEmpty) {
        final map = maps[0];
        return Todo.fromMap(map, id);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("Error reading ToDo: $e");
      }
      return null;
    }
}

@override 
Future<bool> edit(Todo model) async {
  try {
      int count = await _database.update(
        'todos',
        model.toMap(),
        where: 'id = ?',
        whereArgs: [model.id],
      );
      return count > 0;
    } catch (e) {
      if (kDebugMode) {
        print("Error editing ToDo: $e");
      }
      return false;
    }
}

}

