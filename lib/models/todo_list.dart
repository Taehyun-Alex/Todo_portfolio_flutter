import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:ts_todo_portfolio/services/i_datasource.dart';
import './todo.dart';
import 'package:get/get.dart';

class TodoList extends ChangeNotifier {
  final List<Todo> _todos = [];

  UnmodifiableListView<Todo> get todos => UnmodifiableListView(_todos);

  int get todoCount => _todos.length;

  void refresh() async {
    IDatasource dataSource = Get.find();
    RemoveAll();
    _todos.addAll(await dataSource.browse());
  }

  void addTodo(Todo todo) {
    _todos.add(todo);
    notifyListeners();
  }

   void RemoveAll(Todo todo) {
    _todos.clear();
    notifyListeners();
  }

   void Remove(Todo todo) {
    _todos.remove(todo);
    notifyListeners();
  }

  void UpdateTodo(Todo todo) {
    int index = _todos.indexWhere(
      (element) => element.name.toLowerCase() == todo.name.toLowerCase(),
      );
      _todos[index] = todo;
      notifyListeners();
  }
  

}