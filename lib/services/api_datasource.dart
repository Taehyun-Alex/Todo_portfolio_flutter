import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:ts_todo_portfolio/firebase_options.dart';
import 'package:ts_todo_portfolio/models/todo.dart';
import 'package:ts_todo_portfolio/services/i_datasource.dart';

class ApiDataSource implements IDatasource {
  late FirebaseDatabase database;
  late DatabaseReference _todoRef;

  static Future<IDatasource> createAsync() async {
    ApiDataSource datasource = ApiDataSource();
    await datasource.initialise();
    return datasource;
  }

  Future initialise() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    database = FirebaseDatabase.instance;
    _todoRef = database.ref().child('todos'); // Reference to 'todos' collection
  }

  @override
  Future<bool> add(Todo model) async {
    try {
      // Adding new to-do item to Firebase Realtime Database
      await _todoRef.push().set(model.toMap());
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Error adding ToDo: $e");
      }
      return false;
    }
  }

  @override
  Future<List<Todo>> browse() async {
    try {
      DataSnapshot snapshot = await _todoRef.get();
      List<Todo> todos = [];
      if (snapshot.value != null) {
        // Use LinkedHashMap instead of Map<dynamic, dynamic> for Firebase data
        Map<dynamic, dynamic> todoMap = snapshot.value as Map<dynamic, dynamic>;

        todoMap.forEach((key, value) {
          // Cast 'value' to Map<String, dynamic> explicitly
          var todo = Todo.fromMap(
              value as Map<String, dynamic>, key); // Use fromMap method
          todos.add(todo);
        });
      }
      return todos;
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching ToDos: $e");
      }
      return [];
    }
  }

  @override
  Future<bool> delete(Todo model) async {
    try {
      // Deleting to-do item based on its ID
      await _todoRef.child(model.id).remove();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Error deleting ToDo: $e");
      }
      return false;
    }
  }

  @override
  Future<bool> edit(Todo model) async {
    try {
      // Updating to-do item based on its ID
      await _todoRef.child(model.id).update(model.toMap());
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Error editing ToDo: $e");
      }
      return false;
    }
  }

  @override
  Future<Todo?> read(String id) async {
    try {
      DatabaseEvent event =
          await _todoRef.child(id).once(); // Get DatabaseEvent
      DataSnapshot snapshot = event.snapshot; // Access the snapshot
      if (snapshot.value != null) {
        var todo = Todo.fromMap(
            snapshot.value as Map<String, dynamic>, id); // Use fromMap method
        return todo;
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("Error reading ToDo: $e");
      }
      return null;
    }
  }
}
