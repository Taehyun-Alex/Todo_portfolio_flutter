import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ts_todo_portfolio/firebase_options.dart';
import 'package:ts_todo_portfolio/models/todo.dart';
import 'package:ts_todo_portfolio/services/i_datasource.dart';

class APIDataSource implements IDataSource{

  late FirebaseDatabase database;
  static Future<IDataSource> createAsync()async{
    APIDataSource dataSource = APIDataSource();
    await dataSource.initialise();
    return dataSource;
  }
  Future initialise() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);
    database = FirebaseDatabase.instance;
  }
  @override
  Future<bool> add(Todo model) async{
    DatabaseReference ref = database.ref("todos").push();
    Map<String, dynamic> map = model.toMap();
    map['id'] = ref.key;
    await ref.set(map);
    return true;
  }

  @override
  Future<List<Todo>> browse() async{
    DataSnapshot snapshot = await database.ref("todos").get(); //refernce to the todo objs and get will give actual data

    if (!snapshot.exists){
      throw Exception("Invalid Request - No data at location: ${snapshot.ref.path}");
    }
    List<Todo> todos = <Todo>[];
    (snapshot.value as Map).values.map((e)=> Map<String, dynamic>.from(e)).forEach((element){
      element['complete'] = element['completed'];
      todos.add(Todo.fromMap(element));
    });
    return todos;
  }

  @override
  Future<bool> delete(Todo model) async{
    DatabaseReference ref = database.ref("todos/${model.id}");
    await ref.remove();
    return true;
  }

  @override
  Future<bool> edit(Todo model) async{
    DatabaseReference ref = database.ref("todos/${model.id}");
    await ref.update(model.toMap());
    return true;
  }

  @override
  Future<Todo?> read(String id) async{
    DatabaseReference ref = database.ref("todos/$id");
    DataSnapshot snapshot = await ref.get();
    if (snapshot.exists) {
      return Todo.fromMap(Map<String, dynamic>.from(snapshot.value as Map));
    }
    return null;
  }
}