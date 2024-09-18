import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:ts_todo_portfolio/services/i_datasource.dart';
import './todo.dart';
import 'package:get/get.dart';

class TodoList extends ChangeNotifier {
  final List<Todo> _todos = [];

  UnmodifiableListView<Todo> get todos => UnmodifiableListView(_todos);

  int get todoCount => _todos.length;

  Future refresh() async {
    IDatasource dataSource = Get.find();
    RemoveAll();
    _todos.addAll(await dataSource.browse());
    notifyListeners();
  }

  void addTodo(Todo todo) {
    Get.find<IDatasource>().add(todo);
    notifyListeners();
  }

  void removeTodo(Todo todo) async {
    bool isDeleted = await Get.find<IDatasource>().delete(todo);

    if (isDeleted) {
      _todos.remove(todo);
      notifyListeners();
    } else {
      print("Failed to delete the todo.");
    }
  }

  void removeAllTodo() {
    
  }

}