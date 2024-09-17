import 'package:firebase_core/firebase_core.dart';
import 'package:ts_todo_portfolio/firebase_options.dart';
import 'package:ts_todo_portfolio/services/i_datasource.dart';
import './models/todo.dart';
import 'package:ts_todo_portfolio/providers/todo_provider.dart';
import 'package:ts_todo_portfolio/widgets/todo_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:ts_todo_portfolio/services/sql_datasource.dart';
import 'package:uuid/uuid.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ToDoProvider(),
        ),
      ],
      child: const ToDoApp(),
    ),
  );
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const TodoWidget(title: 'To-do'),
    );
  }
}