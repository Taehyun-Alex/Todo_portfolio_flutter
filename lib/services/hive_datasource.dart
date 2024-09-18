import 'package:hive_flutter/adapters.dart';
import 'package:ts_todo_portfolio/services/i_datasource.dart';

import '../models/todo.dart';

class HiveDatasource implements IDataSource{
  static Future<IDataSource> createAsync() async {
    HiveDatasource dataSource = HiveDatasource();
    await dataSource.initialise();
    return dataSource;
  }

  //set up the class and the database
  Future initialise() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TodoAdapter());
    await Hive.openBox<Todo>('todos');    
  }
    
  
  @override
  Future<bool> add(Todo model) async{
    Box<Todo> box = Hive.box('todos');
    int key = await box.add(model);
    await box.put(
      key, 
      Todo(
        id:key.toString(),
        name: model.name,
        description: model.description,
        complete: model. complete
    ));
    print('Todo added with id: $key');
    return true;
  }

  @override
  Future<List<Todo>> browse() async{
    Box<Todo> box = Hive.box('todos');
    return box.values.toList();
  }

  @override
  Future<bool> delete(Todo model) async {
    Box<Todo> box = Hive.box('todos');
    print('Attempting to delete todo with id: ${model.id}');
  
    if (box.containsKey(int.parse(model.id))) {
    await box.delete(int.parse(model.id)); // Delete by key
    print('Deleted todo with id: ${model.id}');
    return true;
    } else {
    print('Todo with id ${model.id} not found.');
    return false; 
    }
  }
  
  @override
  Future<bool> edit (Todo model) async{
    Box<Todo> box = Hive.box('todos');
    int todoId = int.parse(model.id);

    if (box.containsKey(todoId)){
      await box.put(
        todoId, Todo(
          id: model.id, 
        name: model.name, 
        description: model.description,
        complete: model.complete)
      );
      print("Updated todo with id: ${model.id}");
      return true; 
    } else {
      print("Todo with id: ${model.id} not found.");
      return false;
    } 
  }

  @override
  Future<Todo?> read(String id) async{
    Box<Todo> box = Hive.box('todos');
    int todoKey = int.parse(id);

  
  if (box.containsKey(todoKey)) {
    // Return the Todo if found
    return box.get(todoKey);
  } else {
    
    return null;
  }
}
}

