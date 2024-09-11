import 'package:ts_todo_portfolio/services/i_datasource.dart';
import './models/todo.dart';
import 'package:ts_todo_portfolio/models/todo_list.dart';
import 'package:ts_todo_portfolio/widgets/todo_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:ts_todo_portfolio/services/sql_datasource.dart';
import 'package:uuid/uuid.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.putAsync<IDatasource>(() => SQLDataSource.createAsync()).whenComplete(
    () => runApp(
      const TodoApp()));

}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TodoList(),
      builder: (context, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
            useMaterial3: true,
          ),
          debugShowCheckedModeBanner: false,
          home: const HomePage(),
        );
      },
    );
}
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controlName = TextEditingController();
  final TextEditingController _controlDescription = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Todo App',
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(5),
        child: Consumer<TodoList>(
          builder: (context, todoListModel, child) {
            return RefreshIndicator(
              onRefresh: todoListModel.refresh,
              child: ListView.builder(
                itemCount: todoListModel.todoCount,
                itemBuilder: (context, index) {
                  return TodoWidget(
                    todo: todoListModel.todos[index],
                    );
                }
                ),
                );
          }
          )),
      floatingActionButton: FloatingActionButton.large(
        onPressed: _openAddTodo,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add),
            Text('Add'),
          ],
        ),
        ),
      );
  }

  void _openAddTodo() {
    //final uuid = Uuid();
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Name'),
              TextFormField(
                controller: _controlName,
                validator: formTextEmptyValidation,
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: Text('Description'),
              ),
              TextFormField(
                controller: _controlDescription,
                validator: formTextEmptyValidation,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Consumer<TodoList>(
                  builder: (context, todoList, child) {
                    return ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState == null ||
                        !_formKey.currentState!.validate()) return;
                        setState(() {
                          todoList.addTodo(Todo(
                            id: '0',
                            name: _controlName.text,
                            description: _controlDescription.text));
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('Save'),
                      );
                  },
                  ),
                  ),
            ],
          ),
        ),
      );
    },
  );
}
  String? formTextEmptyValidation(String? value) {
  if(value == null || value.isEmpty) {
    return 'Please enter a value!';
  }
  return null;
  }
}