import 'package:hive_flutter/hive_flutter.dart';
import 'package:ts_todo_portfolio/models/todo.dart';
import 'package:ts_todo_portfolio/services/i_datasource.dart';

class HiveDataSource implements IDatasource {
  static Future<IDatasource> createAsync() async {
    HiveDataSource dataSource = HiveDataSource();
    await dataSource.initialise();
    return dataSource;
  }

  Future initialise() async {
    // Set up Hive async
    await Hive.initFlutter();
    Hive.registerAdapter(ToDoAdapter());
    await Hive.openBox<Todo>('todos');
  }

  @override
  Future<bool> add(Todo model) async {
    Box<Todo> box = Hive.box<Todo>('todos');
    await box.put(model.id, model);
    return true;
  }

  @override
  Future<List<Todo>> browse() async {
    Box<Todo> box = Hive.box('todos');
    return box.values.toList();
  }

  @override
  Future<bool> delete(Todo model) async {
    Box<Todo> box = Hive.box<Todo>('todos');
    if (box.containsKey(model.id)) {
      await box.delete(model.id);
      return true;
    }
    return false;
  }

  @override
  Future<bool> edit(Todo model) async {
    Box<Todo> box = Hive.box<Todo>('todos');
    if (box.containsKey(model.id)) {
      await box.put(model.id, model);
      return true;
    }
    return false;
  }

  @override
  Future<Todo?> read(String id) async {
    Box<Todo> box = Hive.box<Todo>('todos');
    return box.get(id);
  }
}
