import 'package:ts_todo_portfolio/models/todo.dart';
import 'package:ts_todo_portfolio/services/i_datasource.dart';
import 'package:flutter/material.dart';
import 'package:ts_todo_portfolio/services/data_service.dart';
import 'package:uuid/uuid.dart';

class ToDoProvider with ChangeNotifier {
  late IDatasource _dataService;

  List<Todo> _todos = [];
  List<Todo> get todos => _todos;

  ToDoProvider() {
    _initializeProvider();
  }

  Future<void> _initializeProvider() async {
    _dataService = await DataService.create(); // Initialise DataService
    await refresh(); // Load initial data
  }

  // Refresh the list of Todos from the data service
  Future<void> refresh() async {
    _todos = await _dataService.browse(); // Fetch data from service
    notifyListeners();
  }

  Future<void> addToDo(String name, String description) async {
    final uuid = const Uuid();
    final newToDo = Todo(
      id: uuid.v4().replaceAll(RegExp(r'[.#$\[\]]'), ''),
      name: name,
      description: description,
      complete: false,
    );
    bool success = await _dataService.add(newToDo);
    if (success) {
      _todos.add(newToDo);
      notifyListeners();
    }
  }

// Update an existing ToDo
  Future<void> updateToDo(int index, String name, String description) async {
    Todo updatedToDo = _todos[index];
    updatedToDo.name = name;
    updatedToDo.description = description;

    bool success = await _dataService.edit(updatedToDo);
    if (success) {
      _todos[index] = updatedToDo;
      notifyListeners();
    }
  }

  // Toggle completion status
  Future<void> toggleToDoStatus(int index) async {
    Todo toDo = _todos[index];
    toDo.complete = !toDo.complete;

    bool success = await _dataService.edit(toDo);
    if (success) {
      _todos[index] = toDo;
      notifyListeners();
    }
  }

  // Delete a Todo
  Future<void> deleteToDo(int index) async {
    bool success = await _dataService.delete(_todos[index]);
    if (success) {
      _todos.removeAt(index);
      notifyListeners();
    }
  }

  Future<void> deleteAll() async {
    for (var toDo in _todos) {
      await _dataService.delete(toDo);
    }

    _todos.clear();
    notifyListeners();
  }

  int get completedCount => _todos.where((todo) => todo.complete).length;

  int get uncompletedCount => _todos.where((todo) => !todo.complete).length;
}
