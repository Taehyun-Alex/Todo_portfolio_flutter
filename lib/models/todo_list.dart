import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:ts_todo_portfolio/services/i_datasource.dart';
import './todo.dart';
import 'package:get/get.dart';

class TodoList extends ChangeNotifier {
  final List<Todo> _todos = [];

  UnmodifiableListView<Todo> get todos => UnmodifiableListView(_todos);

  int get todoCount => _todos.length;

  Future refresh() async{
    IDataSource dataSource = Get.find();
    removeAllTodo();
    _todos.addAll(await dataSource.browse());
    notifyListeners();
  }

  void addTodo(Todo todo) async {
  // Add to the local list first
  _todos.add(todo);
  
  // Persist the change
  await Get.find<IDataSource>().add(todo);
  
  // Notify listeners about the change
  notifyListeners();
}


  void removeTodo(Todo todo) async{
    bool isDeleted = await Get.find<IDataSource>().delete(todo);

    if (isDeleted) {
      _todos.remove(todo);
      notifyListeners();
    } else {
      print("Failed to delete the todo.");
    }
  }
  void removeAllTodo(){
    _todos.clear();
  }
  void updateTodo(Todo updatedTodo) async {
  // Use the 'id' field to find the todo to update
  int index = _todos.indexWhere((todo) => todo.id == updatedTodo.id);

  if (index != -1) {
    // Update the local list first
    _todos[index] = updatedTodo;

    // Call the IDataSource's edit method to persist the changes
    bool isEdited = await Get.find<IDataSource>().edit(updatedTodo);

    if (isEdited) {
      // If edit is successful, notify listeners to refresh the UI
      notifyListeners();
    } else {
      print("Failed to edit the todo.");
    }
  } else {
    print("Todo not found.");
  }
}

}